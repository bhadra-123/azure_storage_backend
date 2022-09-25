void function(String SUB_ID, String CLI_ID, String CLI_SEC) {

  stage ('Alter tfvars') {
    script {
      sh """
        cd ${workspace}/deployments/${Azure_Environment}
        echo Environment     = '"'${Azure_Environment}'"' >> ${Azure_Environment}.tfvars
        echo client_id       = '"'${CLI_ID}'"'            >> ${Azure_Environment}.tfvars
        echo client_secret   = '"'${CLI_SEC}'"'           >> ${Azure_Environment}.tfvars
        echo subscription_id = '"'${SUB_ID}'"'            >> ${Azure_Environment}.tfvars
        echo tenant_id       = '"'${TENANT_ID}'"'         >> ${Azure_Environment}.tfvars
        cat ${Azure_Environment}.tfvars
      """
    }
  }

  stage ('Init') {
    script {
      sh """
        terraform init -upgrade
      """   
    }
  }

  stage ('Plan') {
    script {
      if ( Terraform_Command.equals("Terraform Plan") ||  Terraform_Command.equals("Terraform Apply") || Terraform_Command.equals("Terraform Destroy") ) {
        sh """
          terraform plan \
            -var-file=${workspace}/deployments/${Azure_Environment}/${Azure_Environment}.tfvars \
            -out ${workspace}/deployments/${Azure_Environment}/${Azure_Environment}_plan.txt
        """  
      } 
    }
  }    

  stage ('Apply') {
    script {
      if ( Terraform_Command.equals("Terraform Apply") ) {
        sh """
          terraform apply --auto-approve ${workspace}/deployments/${Azure_Environment}/${Azure_Environment}_plan.txt
        """   
      }
    }
  }

  stage ('Destroy') {
    script {
      if ( Terraform_Command.equals("Terraform Destroy") && Destroy.equalsIgnoreCase("destroy") ) {
          sh """
            terraform plan -destroy \
              -var-file=${workspace}/deployments/${Azure_Environment}/${Azure_Environment}.tfvars \
              -out=${workspace}/deployments/${Azure_Environment}/${Azure_Environment}_destroy.tfplan
            terraform apply --auto-approve ${workspace}/deployments/${Azure_Environment}/${Azure_Environment}_destroy.tfplan
          """   
      }
    }
  }

}

pipeline {

  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr:'2'))
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
    GIT_URL                 = "https://github.com/bhadra-123/azure_storage_backend"
  }

  stages {

    stage('GIT Checkout') {
      steps {
        script {
          checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GITHUB_PAT_TOKEN', url: "${GIT_URL}"]]])
        }
      }
    }

    stage('Function Call') {
      steps {
        script {
          if ( Azure_Environment.equals("dev") ) {
            function("${HUB_SUBSCRIPTION_ID}", "${HUB_CLIENT_ID}", "${HUB_CLIENT_SECRET}")
          }
          else if ( Azure_Environment.equals("qa") ) {
            function("${COMPUTE_SUBSCRIPTION_ID}", "${COMPUTE_CLIENT_ID}", "${COMPUTE_CLIENT_SECRET}")
          }
          else if ( Azure_Environment.equals("prod") ) {
            function("${SPOKE_SUBSCRIPTION_ID}", "${SPOKE_CLIENT_ID}", "${SPOKE_CLIENT_SECRET}")
          }
        }
      }
    }

  }
}