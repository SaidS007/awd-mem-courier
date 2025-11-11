#!/bin/bash
# Extract all line-rate values
values=$(grep -oP 'line-rate="\K[0-9.]+(?=")' coverage/maarch-courrier/cobertura-coverage.xml)

# Convert values to an array
values_array=($values)

# Calculate the sum of values
sum=0
count=0
for value in "${values_array[@]}"; do
    sum=$(echo "$sum + $value" | bc)
    count=$((count + 1))
done

# Calculate the average
if [ $count -gt 0 ]; then
    average=$(echo "$sum / $count" | bc -l)
    coverage_percentage=$(printf "%.2f" $(echo "$average * 100" | bc))
    # Convert comma to dot if necessary
    coverage_percentage=$(echo $coverage_percentage | sed 's/,/./g')
    echo "Coverage: $coverage_percentage%"
    # Export coverage as a GitLab CI environment variable
    echo "CI_JOB_COVERAGE=$coverage_percentage" > src/frontend/test/karmajs/job-coverage.env
else
    echo "Coverage: 0%"
    echo "CI_JOB_COVERAGE=0" > src/frontend/test/karmajs/job-coverage.env
fi
