BEHST Webapp

Behst is a web tool for gene set enrichment an analysis enhanced through integration of chromatin long-range interactions. The user uploads a (.bed) file for analysis and the optional parameters. The application will then output a list of the most significant Gene Ontology terms and the user will be redirected to g:Profiler site, with the terms in the query. It is currently running at http://behst.hoffmanlab.org/behst

Software
NodeJs Node modules (run the command “npm install” in the root directory of the application) Behst (https://bitbucket.org/hoffmanlab/behst follow the instructions to download, but the files should already be in the application)

Before you Begin
Read up on docker as we use some terminology of it in the documentation of Behst. https://docs.docker.com/get-started/
Useful Commands in Production

The app is in a docker container hosted at UHN’s Merry server. Here is a list of commands you may find useful.
To start the container: docker run -v /data/web/data_behst:/app/behst/uploads --name behst -p 4000:3000 behst:latest
If you do not need to make a new image, then use the commands: docker start (to start the container) docker stop (to stop the container)

Making Changes to the Application (locally)

The files for the application are found under (/coop2/coop_S17/behst) in mordor. To launch the application locally type “node app.js” in the root directory.

To launch the application in a docker container with the given dockerfile, use the following commands
docker build –t behst behst_docker (to build the docker image) ducker run –p 4000:3000 behst (to start the application in the docker container)

The default page for the application is http://localhost:3000/behst, and I advise not to change this as this will cause difficulties in production. Before you publish the files for production, make sure to test the application in the docker container.

Making Changes to the Application (live)
The application is hosted on the server, Merry. In order to ssh into it, first ssh into Mordor, then ssh into Merry. It is currently running in a docker container on this server, and in order to access the files type "docker exec -t -i containerid bash".

If you want to add files to the application, you have to first sftp it into Mordor, then Merry, then use the command "docker cp : containerid "

Changes to the front end are automatic. Changes to the backend however are not. Use the command "docker restart containerid" to restart the application.

If somehow the container crashes use the command "docker run behst"

If you want to rebuild the entire container, delete the current container, then use the command "docker run -v 
/data/web/data_behst:/app/behst/uploads --name behst -p 4000:3000 behst"

The BEHST webpage backend requires the following libraries:

Express

fs

child_process

http

request

encodeQueryData

This function encodes a URI using &s This function is no longer used.

cleanUploadResultsAndUploads

This function wwill go through each folder in the behst/uploadResults directory, check if it is the file with name "bed_name" and then delete it.

execBehst

This function calls BEHST and runs the processing that occurs afterwards. First it runs the BEHST application, which generates a gene list. It extracts the gene list from the file, then renders a page where this gene list is inserted into a textarea.
Upon pressing the submit button, a POST request is made to http://biit.cs.ut.ee/gprofiler/index.cgi with the query being the list of genes. You may have to wait a few minutes for the page to load as it can be rather slow.

checkIfFile

Checks if the file exists using Node's fs.stat(). Asynchronous.

downloadFileOrURI

Returns a promise. Checks if the URI is a web link or if it's a local link and tries to download the file via a request. If the file already exists in the local data library, it will instead use that version.

Image of the Flow of the Application
