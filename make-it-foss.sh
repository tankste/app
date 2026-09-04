#!/bin/bash

# location
rm -R location/impl_closed
sed -i '' 's/impl_closed/impl_foss/g' location/location/pubspec.yaml
sed -i '' '/^pub_get location\/impl_closed/d' get-deps.sh

# sponsor
rm -R sponsor/data_closed
sed -i '' 's/data_closed/data_foss/g' sponsor/ui/pubspec.yaml
sed -i '' '/^pub_get sponsor\/data_closed/d' get-deps.sh

# review
rm -R review/impl_closed
sed -i '' 's/impl_closed/impl_foss/g' review/review/pubspec.yaml
sed -i '' '/^pub_get review\/impl_closed/d' get-deps.sh

# map
rm -R map/google_closed
rm -R map/apple_closed
sed -i '' 's/google_closed/google_foss/g' map/map/pubspec.yaml
sed -i '' 's/apple_closed/apple_foss/g' map/map/pubspec.yaml
sed -i '' '/^pub_get map\/google_closed/d' get-deps.sh
sed -i '' '/^pub_get map\/apple_closed$/d' get-deps.sh

