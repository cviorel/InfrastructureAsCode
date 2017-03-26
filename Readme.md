#Presentation on infrastructure as code.
Code to run the demo can be found in the DigitalOcean directory.

Run the directories inside are number in the order they need to be done.

01_Packer will first create an image for you in digital ocean.

02_Terraform will then spin up 5 servers for you and set up DNS.

03_Docker will then use docker-machine to set up and create a docker swarm. Start a replicated postgres 
and load a simple app.

Some things you will need 
* DigitalOcean api key (https://www.digitalocean.com/help/api/)
* Domain to load ip's into
* Digital ocean ssh key finger print (https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean)
* Docker Machine installed (https://docs.docker.com/machine/)

##Assumptions

This was built and tested on a Mac. It should work on other operating systems but may require some tweaking.

##01_Packer
This contains the files needed to create the server image that is then used later by Terraform

Copy the file ubuntu_packer_do_uk.example.json to ubuntu_packer_do_uk.json and change the YOUR_API key 
to your DigitalOcean api key (https://www.digitalocean.com/help/api/)

Then run ```./runDoUk.sh``` or ```packer build ubuntu_packer_do_uk.json```

At the end of the creation process it will print out and id number. Grab this for your next step.

After this you should have an image sitting in DigitalOcean ready for the next step.

##02_Terraform
Copy variable.tf.example to variable.tf and change MY_SSH_KEY_FINGER_PRINT to your key's fingerprint, 
change MY_DOMAIN to your domain and change MY_IMAGE_ID to the image id that you got when using packer.

Run 

```terraform apply``` 

If for some reason something fails. Just run it again. It is safe to run multiple times.

##03_Docker
Change DOMAIN=custd.co in ```deploy.sh``` to your domain.

Then run the commands inside the  ```deploy.sh``` script. 

##Tear down
Once your done playing just run ```terraform destroy``` in the 02_Terraform directory. 

This will remove all the servers and dns.
 
You can also change docker_server_count to 0 and run ```terraform apply```.

To do a total clean up you will also need to delete the image created by packer.




