<cfscript>

// https://bitbucket.org/lucee/lucee/wiki/Cookbook_Configuration_Administrator_CFC

// first argument is the admin type you wanna load (web|server), second the password for the Administrator
admin = new Administrator( 'server', 'lucee_server_password' );

// set the resource charset as an example
admin.updateCharset(resourceCharset:"UTF-8");

</cfscript>
<!--- set localhost:25 (postfix) as the default smtp server --->
<cfadmin action="updateMailServer"
  type="server"
  password="lucee_server_password"
  hostname="localhost"
  dbusername=""
  dbpassword=""
  port="25"
  id=""
  tls="FALSE"
  ssl="FALSE"
  remoteClients="">
<cfscript>

writeoutput( 'kickstart.cfm completed successfully' );
</cfscript>