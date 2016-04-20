# dockerlocker
simple docker preparations
===========

##DOCKER


### installing docker
https://docs.docker.com/mac/step_one/

following that page's instuctions should get you to a point where `docker` is a command line item
```
docker help
```
should return something other than
`bash: docker: command not found`





###NGINX start
Using docker to kickoff the local webapp using the nginx container

From the console, if your current working directory matches *this* file's path, you are ok to proceed.

If not cd into *this* file's path in your console/terminal window.

Then take note of the path for your local copy of the webapp build path after doing an `npm build`
Whatever that path is, it should contain an index.html file that nginx will serve.

e.g. /home/user/github/webapp/build
OR   /Users/username/github/projectone/build

Then use the following command to start a docker image that runs nginx and uses this path to serve pages.

```
./nginx/prepare.sh run PATH/TO/YOUR/WEBAPP/ROOT
```

Feel free to modify the ports used in the prepare.sh script to suit your purpose for testing.
