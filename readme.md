ios4che - open source iOS viewer app implementation for DCM4CHE Wado Service

<h3>Requirements</h3>
<ol>
<li>DCM4CHEE-2.18.0-psql & postgresql database</li>
<li>Web services</li>
</ol>


<h3> How to install </h3>
<ol>
<li>Download and install dcm4chee-2.18.0-psql http://www.dcm4che.org/confluence/display/ee2/Installation or downlad the automated installer from  https://github.com/gokhandilek/dcm4chee-installer</li>
<li>Check the server logs and make sure there is no error (server/default/logs).</li>
<li>Send studies to dcm4cheee</li>
<li>Check to make sure you can access the images using Wado via dcm4chee web interface (localhost:8080/dcm4chee-web3)</li>
<li>Copy the directory Web Services to dcm4chee-2.18.0/server/default/deploy</li>
<li>Rename the web services directory to whatever-you-wish-to-name-it.war(make sure the extension of the directory is .war otherwise the app will not connect!).</li>
<li>Edit the files inside the web service directory according to your database connection credentials(default is database username: pascdb username: postgres password:password). You must also configure this otherwise the app will not work!</li>
</ol>

<h3> How to update <h3>
Once a new version is released, you may have to update the app and the web services provided at the same time. Otherwise the app will not function properly.
<li>Copy the directory Web Services to dcm4chee-2.18.0/server/default/deploy/whatever-you-named-it.war and replace the existing files</li>
<li>Edit the database connection credentials</li>
<li>Delete the app from your iOS device.</li>
<li>Run and recompile the project</li>

<h3>Contributions and Feedback</h3>

If you are interesting in contributing to the project, please contact me. I would like to hear your feedback and feature requests.
Thank you.

