task :brakeman do
  sh <<end
mkdir -p tmp && (brakeman --no-progress --quiet --output tmp/brakeman.out --exit-on-warn && echo "no warnings or errors") || (cat tmp/brakeman.out;)
end
end
