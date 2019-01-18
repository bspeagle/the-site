node {
    stage('Clone source') {
        sh 'rm -f the-site'
        git url: 'https://github.com/bspeagle/the-site.git'
    }
    
    stage('Terraform!') {
        dir ('terraform/prod/') {
            echo 'Getting .tfstate file from S3...'
            try {
                    sh 'aws s3 cp s3://bspeagle.com/terraform.tfstate .'
                }
                catch(Exception ex) {
                    echo '.tfstate file does not exist yet. Moving on.'
                }
            sh 'terraform init'
            sh 'aws s3 cp s3://bspeagle.com/terraform.tfvars ../files'
            try {
                sh 'terraform apply --auto-approve --var-file="../files/terraform.tfvars"'
            }
            catch(Exception ex) {
                echo 'Terraform apply failed :('
                
            }
            echo 'Uploading .tfstate to S3'
            sh 'aws s3 cp ./terraform.tfstate s3://bspeagle.com'
        }
    }

    stage('Deploy updates to ECS ENV') {
        sh 'aws ecs update-service --cluster the-site-PROD --service the-site-App-Deploy --force-new-deployment --region us-east-1'
    }
}