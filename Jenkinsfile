@Library('jenkins-shared-library') _
node {
  withCredentials ([
    string(credentialsId: 'TENANT_ID', variable: 'ARM_TENANT_ID'),
    string(credentialsId: 'HUB_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
    string(credentialsId: 'HUB_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
    string(credentialsId: 'HUB_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
    string(credentialsId: 'SPOKE_SUBSCRIPTION_ID', variable: 'TF_VAR_SUBSCRIPTION_ID'),
    string(credentialsId: 'SPOKE_CLIENT_ID', variable: 'TF_VAR_CLIENT_ID'),
    string(credentialsId: 'SPOKE_CLIENT_SECRET', variable: 'TF_VAR_CLIENT_SECRET')    
  ]) 
  {
    withEnv(["git_url=https://github.com/bhadra-123/terraform_storage_backend"]) {

      ansiColor('xterm') {

        properties ([
            parameters ([
                choice(name: 'Terraform_Command', choices: 'Terraform Plan\nTerraform Apply\nTerraform Destroy'),
                choice(name: 'Azure_Environment', choices: 'dev\nprod'),
                string(name: 'Destroy', defaultValue: '', description: 'Confirm Destroy by typing the word "destroy"' )
            ])
        ])

        stage ('GIT Checkout') {
          checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GITHUB_PAT_TOKEN', url: "${git_url}"]]])
        }         

        def call(String SUB_ID, String CLI_ID, String CLI_SEC, String TF_COMMAND) {

          stage('azlogin') {
              script {
                  sh """
                      az account clear
                      az login --service-principal -u ${CLI_ID} -p ${CLI_SEC} -t ${ARM_TENANT_ID}
                      az account set -s ${SUB_ID}
                      az account show
                  """  
              }
          }

          stage('Init') {
              script {
                  sh """
                      cd ${workspace}/${Azure_Environment}
                      terraform init
                  """   
              }
          }

          stage('Plan') {
              script {
                  if ( TF_COMMAND.equals("Terraform Plan") ||  TF_COMMAND.equals("Terraform Apply") || TF_COMMAND.equals("Terraform Destroy") ) {
                      sh """
                          cd ${workspace}/${Azure_Environment}
                          terraform plan -var Environment=${Azure_Environment} -var-file=${Azure_Environment}.tfvars 
                      """  
                  } 
              }
          }

          stage('Apply') {
              script {
                  if ( TF_COMMAND.equals("Terraform Apply") ) {
                      sh """
                          cd ${workspace}/${Azure_Environment}
                          terraform apply --auto-approve -var Environment=${Azure_Environment} -var-file=${Azure_Environment}.tfvars 
                      """   
                  }
              }
          }

          stage('Destroy') {
              script {
                  if ( TF_COMMAND.equals("Terraform Destroy") && Destroy.equalsIgnoreCase("destroy") ) {
                      sh """
                          cd ${workspace}/${Azure_Environment}
                          terraform destroy --auto-approve -var Environment=${Azure_Environment} -var-file=${Azure_Environment}.tfvars 
                      """   
                  }
              }
          }                       

          if ( Azure_Environment.equals("dev") ) {
            call "${ARM_SUBSCRIPTION_ID}", "${ARM_CLIENT_ID}", "${ARM_CLIENT_SECRET}", "${Terraform_Command}"
          }
          else if ( Azure_Environment.equals("prod") ) {
            call "${TF_VAR_SUBSCRIPTION_ID}", "${TF_VAR_CLIENT_ID}", "${TF_VAR_CLIENT_SECRET}", "${Terraform_Command}"
          }
        }
      }
    } 
  }
}

/////////////////////////////////
// Working Jenkinsfile Backup //
///////////////////////////////

// @Library('jenkins-shared-library') _
// node {
//   withCredentials ([
//     string(credentialsId: 'TENANT_ID', variable: 'ARM_TENANT_ID'),
//     string(credentialsId: 'HUB_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
//     string(credentialsId: 'HUB_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
//     string(credentialsId: 'HUB_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
//     string(credentialsId: 'SPOKE_SUBSCRIPTION_ID', variable: 'TF_VAR_SUBSCRIPTION_ID'),
//     string(credentialsId: 'SPOKE_CLIENT_ID', variable: 'TF_VAR_CLIENT_ID'),
//     string(credentialsId: 'SPOKE_CLIENT_SECRET', variable: 'TF_VAR_CLIENT_SECRET')    
//   ]) 
//   {
//     withEnv(["git_url=https://github.com/bhadra-123/terraform_storage_backend"]) {

//       ansiColor('xterm') {

//         properties ([
//             parameters ([
//                 choice(name: 'Terraform_Command', choices: 'Terraform Plan\nTerraform Apply\nTerraform Destroy'),
//                 choice(name: 'Azure_Environment', choices: 'dev\nprod'),
//                 string(name: 'Destroy', defaultValue: '', description: 'Confirm Destroy by typing the word "destroy"' )
//             ])
//         ])          

//         stage('GIT Checkout') {
//           checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GITHUB_PAT_TOKEN', url: "${git_url}"]]])
//         }       

//         if ( Azure_Environment.equals("dev") ) {
//           GetJenkinsSecretIds "${ARM_SUBSCRIPTION_ID}", "${ARM_CLIENT_ID}", "${ARM_CLIENT_SECRET}", "${Terraform_Command}"
//         }
//         else if ( Azure_Environment.equals("prod") ) {
//           GetJenkinsSecretIds "${TF_VAR_SUBSCRIPTION_ID}", "${TF_VAR_CLIENT_ID}", "${TF_VAR_CLIENT_SECRET}", "${Terraform_Command}"
//         }

//       }
//     } 
//   }
// }


