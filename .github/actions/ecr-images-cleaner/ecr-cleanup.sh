#!/usr/bin/env bash

set -eo pipefail

ecr_repo="${ECR_REPO_NAME}"
namespace="${KUBE_NAMESPACE}"

# Additional tags that should not be deleted, in addition to the replica set tags.
regex_tags="${ADDITIONAL_TAGS_REGEX}"

# Number of days to keep images. Any image older than these days (not including images used in replica sets)
# will be purge, unless it falls inside `max_old_images_to_keep`.
days_to_keep_old_images="${DAYS_TO_KEEP_OLD_IMAGES}"

# Number of images to keep even if they are older than the cutoff date (not including images used in replica sets)
# This ensures a buffer of images, even if there are no deploys for several months, just in case as a precaution.
max_old_images_to_keep="${MAX_OLD_IMAGES_TO_KEEP}"

# Amazon AWS region. As this is unlikely to change, for now it is hardcoded, but is easy to extract to a variable.
region='eu-west-2'

# AWS BatchDeleteImage has a limit of 100 imageIds per call. If it ever changes, update this variable.
batch_delete_limit=100

function image_count() {
  local image_count=$(aws ecr list-images --region $region --repository-name $ecr_repo | jq '.imageIds | length')
  echo $image_count
}

# This will return a string of docker image tags, tokenized by pipes to be used as a regex input.
# Example: 44814e41d8ea7f449f3391fe5d4b9763ddbbd06d|f4c73b2f047d49270de5c6779c921ca819117674|af4e24ee011425c4e26329d887bf9bdf9172b8bf
function replicaset_images() {
  local rs_tags=$(kubectl get replicaset -n $namespace -o jsonpath='{..image}' | tr ' ' '\n' | sed 's/.*://' | tr '\n' '|')
  echo $rs_tags
}

function delete_images() {
  if [[ $# -ne 1 ]]; then echo "$0: wrong number of arguments"; return 1; fi
  local response=$(aws ecr batch-delete-image --region $region --repository-name $ecr_repo --image-ids "$1")
  local successes=$(echo $response | jq '.imageIds | length')
  local failures=$(echo $response | jq '.failures | length')
  echo "Successes: $successes"
  echo "Failures: $failures"
}

echo "Authenticating to the EKS cluster to retrieve replica sets history..."
echo "${KUBE_CERT}" > ca.crt
kubectl config set-cluster ${KUBE_CLUSTER} --certificate-authority=./ca.crt --server=https://${KUBE_CLUSTER}
kubectl config set-credentials deploy-user --token=${KUBE_TOKEN}
kubectl config set-context ${KUBE_CLUSTER} --cluster=${KUBE_CLUSTER} --user=deploy-user --namespace=${KUBE_NAMESPACE}
kubectl config use-context ${KUBE_CLUSTER}

replicaset_tags=$(replicaset_images)
echo -e "Image tags used in ReplicaSet history in authenticated namespace:\n$replicaset_tags"
echo "Additional tags to keep (regex): '$regex_tags'"

retention_time_ms=$(($days_to_keep_old_images*60*60*24))
retention_cut_off_epoch=$(($(date '+%s')-$retention_time_ms))
retention_cut_off_date=$(echo $retention_cut_off_epoch | jq 'todate')
echo "Retention cutoff date: $retention_cut_off_date ($days_to_keep_old_images days or older)"
echo

images_to_delete=$(aws ecr describe-images --region $region --repository-name $ecr_repo | jq "{imageDetails: [.imageDetails[] | select(.imageTags // [] | any(match(\"^($replicaset_tags|$regex_tags)$\")) | not ) | select(.imagePushedAt <= $retention_cut_off_date)] | sort_by(.imagePushedAt) | .[0:-$max_old_images_to_keep] }")
images_to_delete_count=$(echo $images_to_delete | jq '.imageDetails | length')
echo "Total images to delete: $images_to_delete_count (excluding replicaset images and a buffer of $max_old_images_to_keep images)"

if [[ ${images_to_delete_count} -gt ${batch_delete_limit} ]]; then
  echo "There are more than $batch_delete_limit images to delete but BatchDeleteImage operation can only delete $batch_delete_limit at a time. Next run of the script will delete remaining images."
fi

echo
echo "Deleting images now..."
echo "Images before cleaning: $(image_count)"

if [[ ${images_to_delete_count} -gt 0 ]]; then
  image_digests=$(echo $images_to_delete | jq "[{ imageDigest: .imageDetails[].imageDigest }] | .[0:$batch_delete_limit]")
  delete_images "$image_digests"
  echo "Images deletion complete"
else
  echo "There are no images to delete"
fi

echo "Images after cleaning: $(image_count)"
echo
echo "Job done."
