node {
    stage('Clone source') {
        sh 'rm -f the-site'
        git url: 'https://github.com/bspeagle/the-site.git'
    }

    stage('Get ENV variables from S3') {
        sh 'aws s3 cp s3://bspeagle.com/.env .'
    }

    stage('Build Docker Image') {        
        sh '$(aws ecr get-login --no-include-email --region us-east-1)'
        sh 'docker build -t the-site .'
        sh 'docker tag the-site:latest 367592122643.dkr.ecr.us-east-1.amazonaws.com/the-site:latest'
    }

    stage('Push Docker Image to ECR') {
        sh 'docker push 367592122643.dkr.ecr.us-east-1.amazonaws.com/the-site:latest'
    }
}