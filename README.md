# the-site
BSPEAGLE.com

Nothing terribly exciting here folks. Calm down. 

The site is a Laravel project and main page uses as jQuery library (https://terminal.jcubic.pl/) for emulating a terminal in browser.

The infrastructure is managed by Terraform and creates an ECS cluster off a single EC2 instance. There's also Jenkins deployment pipelines and docker files.

If you have Jenkins (if you don't but want to jump into Jenkins I have another repo with an easy installer for Jenkins in AWS) and AWS and want to use ECS, ECR and container services with your site you could easily rip out the main site and use the rest for your own. Just sayin.

What's included:

- The site is wrapped in Laravel so most of what you see if Laravel core files.

- jenkins/ - pipelines used by Jenkins for deployment.

- terraform/ - infrastructure used by site, managed by terraform.

- dockerfile - docker file and .dockerignore included.