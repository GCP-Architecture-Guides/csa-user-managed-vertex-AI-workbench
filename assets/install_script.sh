##  Copyright 2023 Google LLC
##  
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##  
##      https://www.apache.org/licenses/LICENSE-2.0
##  
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.


##  This code creates demo environment for CSA Network Firewall microsegmentation 
##  This demo code is not built for production workload ##

#!/bin/bash
 
sudo apt-get update -y 
  echo "Current user: `id`" >> /tmp/notebook_config.log 2>&1
  echo "Changing dir to /home/jupyter" >> /tmp/notebook_config.log 2>&1
  export PATH="/home/jupyter/.local/bin:$PATH"
  cd /home/jupyter
  echo "Cloning generative-ai from github" >> /tmp/notebook_config.log 2>&1
  su - jupyter -c "git clone https://github.com/mgaur10/vertex-ai-dlp.git" >> /tmp/notebook_config.log 2>&1
  echo "Current user: `id`" >> /tmp/notebook_config.log 2>&1
  echo "Installing python packages" >> /tmp/notebook_config.log 2&1
  su - jupyter -c "pip install --upgrade --no-warn-conflicts --no-warn-script-location --user \
      google-cloud-bigquery \
      google-cloud-pipeline-components \
      google-cloud-aiplatform \
      seaborn \
      kfp" >> /tmp/notebook_config.log 2>&1
