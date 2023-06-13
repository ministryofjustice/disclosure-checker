task brakeman: :environment do
  sh <<~END
    mkdir -p tmp && (brakeman --no-progress --quiet --output tmp/brakeman.out --exit-on-warn && echo "no warnings or errors") || (cat tmp/brakeman.out;)
  END
end
