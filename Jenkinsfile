@Library('jenkins-shared-library') _

pipeline {

  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr:'5'))
    timeout(time: 5, unit: 'MINUTES')
    ansiColor('xterm')
  }

  parameters{
    choice(name: 'Terraform_Command', choices: 'Terraform Plan\nTerraform Apply\nTerraform Destroy')
    choice(name: 'Azure_Environment', choices: 'dev\nqa\nprod')
    string(name: 'Destroy', defaultValue: '', description: 'Confirm Destroy by typing the word "destroy"' )
  }

  environment {
    TENANT_ID               = credentials("TENANT_ID")
    HUB_SUBSCRIPTION_ID     = credentials("HUB_SUBSCRIPTION_ID") 
    HUB_CLIENT_ID           = credentials("HUB_CLIENT_ID") 
    HUB_CLIENT_SECRET       = credentials("HUB_CLIENT_SECRET") 
    COMPUTE_SUBSCRIPTION_ID = credentials("COMPUTE_SUBSCRIPTION_ID") 
    COMPUTE_CLIENT_ID       = credentials("COMPUTE_CLIENT_ID") 
    COMPUTE_CLIENT_SECRET   = credentials("COMPUTE_CLIENT_SECRET")    
    SPOKE_SUBSCRIPTION_ID   = credentials("SPOKE_SUBSCRIPTION_ID")
    SPOKE_CLIENT_ID         = credentials("SPOKE_CLIENT_ID") 
    SPOKE_CLIENT_SECRET     = credentials("SPOKE_CLIENT_SECRET")
    git_url                 = "https://github.com/bhadra-123/terraform_storage_backend"
  }

  stages {

    stage('GIT Checkout') {
      checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GITHUB_PAT_TOKEN', url: "${git_url}"]]])
    }       

    if ( Azure_Environment.equals("dev") ) {
      TerrafromJenkins "${HUB_SUBSCRIPTION_ID}", "${HUB_CLIENT_ID}", "${HUB_CLIENT_SECRET}"
    }
    else if ( Azure_Environment.equals("qa") ) {
      TerrafromJenkins "${COMPUTE_SUBSCRIPTION_ID}", "${COMPUTE_CLIENT_ID}", "${COMPUTE_CLIENT_SECRET}"
    }
    else if ( Azure_Environment.equals("prod") ) {
      TerrafromJenkins "${SPOKE_SUBSCRIPTION_ID}", "${SPOKE_CLIENT_ID}", "${SPOKE_CLIENT_SECRET}"
    }

  }
}


/////////////////////////////////
// Working Jenkinsfile Backup //
///////////////////////////////

// @Library('jenkins-shared-library') _

// node {
//   withCredentials ([
//     string(credentialsId: 'TENANT_ID', variable: 'TENANT_ID'),
//     string(credentialsId: 'HUB_SUBSCRIPTION_ID', variable: 'HUB_SUBSCRIPTION_ID'),
//     string(credentialsId: 'HUB_CLIENT_ID', variable: 'HUB_CLIENT_ID'),
//     string(credentialsId: 'HUB_CLIENT_SECRET', variable: 'HUB_CLIENT_SECRET'),
//     string(credentialsId: 'COMPUTE_SUBSCRIPTION_ID', variable: 'COMPUTE_SUBSCRIPTION_ID'),
//     string(credentialsId: 'COMPUTE_CLIENT_ID', variable: 'COMPUTE_CLIENT_ID'),
//     string(credentialsId: 'COMPUTE_CLIENT_SECRET', variable: 'COMPUTE_CLIENT_SECRET'),    
//     string(credentialsId: 'SPOKE_SUBSCRIPTION_ID', variable: 'SPOKE_SUBSCRIPTION_ID'),
//     string(credentialsId: 'SPOKE_CLIENT_ID', variable: 'SPOKE_CLIENT_ID'),
//     string(credentialsId: 'SPOKE_CLIENT_SECRET', variable: 'SPOKE_CLIENT_SECRET')    
//   ]) 
//   {
//     withEnv([ "git_url=https://github.com/bhadra-123/terraform_storage_backend"]) {

//       ansiColor('xterm') {
        
//         properties ([
//             parameters ([
//                 choice(name: 'Terraform_Command', choices: 'Terraform Plan\nTerraform Apply\nTerraform Destroy'),
//                 choice(name: 'Azure_Environment', choices: 'dev\nqa\nprod'),
//                 string(name: 'Destroy', defaultValue: '', description: 'Confirm Destroy by typing the word "destroy"' )
//             ])
//         ])          

//         stage('GIT Checkout') {
//           checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GITHUB_PAT_TOKEN', url: "${git_url}"]]])
//         }       

//         if ( Azure_Environment.equals("dev") ) {
//           TerrafromJenkins "${HUB_SUBSCRIPTION_ID}", "${HUB_CLIENT_ID}", "${HUB_CLIENT_SECRET}"
//         }
//         else if ( Azure_Environment.equals("qa") ) {
//           TerrafromJenkins "${COMPUTE_SUBSCRIPTION_ID}", "${COMPUTE_CLIENT_ID}", "${COMPUTE_CLIENT_SECRET}"
//         }
//         else if ( Azure_Environment.equals("prod") ) {
//           TerrafromJenkins "${SPOKE_SUBSCRIPTION_ID}", "${SPOKE_CLIENT_ID}", "${SPOKE_CLIENT_SECRET}"
//         }        

//       }
//     } 
//   }
// }


