@extends('layouts.app')

@section('styles')
<link href="css/style.css" rel="stylesheet"/>
@endsection

@section('content')
<div>Dantastic Dot Org</div>
<div>Powered by whiskey and apathy</div>
<div>
    <h1>Adding a vRO PowerShell Host – Kerberos Configuration</h1>
    <h2>Published: Wednesday, 30 September 2015 10:12</h2>
    <p>Hey all, thanks for stopping by!</p>
    <p>Here is a quick post of issues I ran into and changes I made to successfully add a PowerShell host to my vRealize Orchestrator (vRO) configuration. Now, this has been covered at length by a few posts provided in the resources section, so review them first as they may solve your problems. This post addresses the problems I saw in my lab.</p>
    <ol>
        <li>List of errors I ran into in vRO when running the ‘Add PowerShell Host’ workflow:
            <em>Unauthorized Access. Authentication mechanism requested by the client may not be supported by the server. (Dynamic Script Module name : addPowerShellHost#16</em>
        </li>
        <li>Cannot locate KDC</li>
    </ol>
    <p><strong>Authentication Types:</strong>One of the first things you will notice is that there are (2) authentication types you can specify when running the “Add a PowerShell host” workflow.</p>
    <ol>
        <li>Basic (Used this for local accounts created on the PowerShell Host)
            <ul>
                <li>The only way I could get this to work was to use a local account on the machine. Even though the Active Directory plug-in is installed and configured, I was unable to use an AD account with basic authentication. My guess is the PowerShell plug-in doesn’t leverage the AD plugin for authentication (I may also be missing something, please comment if so).</li>
                <li>Errors received when using a DOMAIN account:Unauthorized Access. Authentication mechanism requested by the client may not be supported by the server. (Dynamic Script Module name : addPowerShellHost#16</li>
                <li>NOTE: When I used a LOCAL account on the PowerShell host, the workflow successfully added the host.</li>
            </ul>
        </li>
        <li>Kerberos (Had to use this for Active Directory Accounts)I wanted to use an account I could manage via Active Directory and Group Policy so a local account wasn’t an option.
            <ul>
                <li>In order to configure vRO for Kerberos, the krb5.conf configuration file had to be added to the vRO Appliance.</li>
            </ul>
        </li>
    </ol>
    <h3><strong>Resources:</strong>First, give these a shot and see if they take care of your issues. These posts helped push me in the right direction:</h3>
    <ol>
        <li><a rel="nofollow" href="http://blog.mwpreston.net/2013/12/12/kerberos-authentication-for-the-powershell-plugin-in-vco-5-5/">http://blog.mwpreston.net/2013/12/12/kerberos-authentication-for-the-powershell-plugin-in-vco-5-5/</a></li>
        <li><a rel="nofollow" href="http://www.definit.co.uk/2014/07/configuring-vcenter-orchestrator-vco-with-powershell-over-https-with-kerberos-authentication/">http://www.definit.co.uk/2014/07/configuring-vcenter-orchestrator-vco-with-powershell-over-https-with-kerberos-authentication/</a></li>
        <li><a rel="nofollow" href="http://kaloferov.com/blog/adding-vco-powershell-host-with-account-other-than-the-default-domain-administrator-account/">http://kaloferov.com/blog/adding-vco-powershell-host-with-account-other-than-the-default-domain-administrator-account/</a></li>
    </ol><p>Here is the basic process I had to follow to get this working in my lab:</p>
    <ol>
        <li>Configure winRM on the PowerShell host</li>
        <li>Add the required krb5.conf file. See resource 1 above.</li>
        <li>Restart the vco-service:
            <ol>
                <li>SSH to the vRO Appliance</li>
                <li>/etc/init.d/vco-server restart</li>
            </ol>
        </li>
        <li>Run the ‘Add PowerShell Host’ Workflow using the correct username convention. Format the account as “<span id="cloak9442e42e95519a3a347d696849c4d250">This email address is being protected from spambots. You need JavaScript enabled to view it.</span>
            <script type='text/javascript'>
                document.getElementById('cloak9442e42e95519a3a347d696849c4d250').innerHTML = '';
                var prefix = '&#109;a' + 'i&#108;' + '&#116;o';
                var path = 'hr' + 'ef' + '=';
                var addy9442e42e95519a3a347d696849c4d250 = '&#117;s&#101;r' + '&#64;';
                addy9442e42e95519a3a347d696849c4d250 = addy9442e42e95519a3a347d696849c4d250 + 'd&#111;m&#97;&#105;n' + '&#46;' + 'c&#111;m';
                var addy_text9442e42e95519a3a347d696849c4d250 = '&#117;s&#101;r' + '&#64;' + 'd&#111;m&#97;&#105;n' + '&#46;' + 'c&#111;m';document.getElementById('cloak9442e42e95519a3a347d696849c4d250').innerHTML += '<a ' + path + '\'' + prefix + ':' + addy9442e42e95519a3a347d696849c4d250 + '\'>'+addy_text9442e42e95519a3a347d696849c4d250+'<\/a>';
            </script>
        ”.</li>
    </ol>
    <p>Here is an example of my <strong>krb5.conf</strong> configuration for ‘valcolabs.lab’.</p>
    <p>[libdefaults]default_realm = VALCOLABS.LAB[realms]VALCOLABS.LAB = {kdc = uber-dc01.valcolabs.labdefault_domain = valcolabs.lab}[domain_realms].valcolabs.lab=VALCOLABS.LABvalcolabs.lab=VALCOLABS.LAB[logging]kdc = FILE:/var/log/krb5/krb5kdc.logadmin_server = FILE:/var/log/krb5/kadmind.logdefault = SYSLOG:NOTICE:DAEMON</p>
    <p>Using “domain\user” resulted in an error stating that the KDC could not be contacted.</p><p>Error when using down-level login name: “domain\user”</p>
    <p>Correct format: Using the user principal name (UPN): “<span id="cloak38dab490e8f68bca0da0d0feeb9a04de">This email address is being protected from spambots. You need JavaScript enabled to view it.</span>
        <script type='text/javascript'>
            document.getElementById('cloak38dab490e8f68bca0da0d0feeb9a04de').innerHTML = '';
            var prefix = '&#109;a' + 'i&#108;' + '&#116;o';
            var path = 'hr' + 'ef' + '=';
            var addy38dab490e8f68bca0da0d0feeb9a04de = '&#117;s&#101;r' + '&#64;';
            addy38dab490e8f68bca0da0d0feeb9a04de = addy38dab490e8f68bca0da0d0feeb9a04de + 'd&#111;m&#97;&#105;n' + '&#46;' + 'c&#111;m';
            var addy_text38dab490e8f68bca0da0d0feeb9a04de = '&#117;s&#101;r' + '&#64;' + 'd&#111;m&#97;&#105;n' + '&#46;' + 'c&#111;m';document.getElementById('cloak38dab490e8f68bca0da0d0feeb9a04de').innerHTML += '<a ' + path + '\'' + prefix + ':' + addy38dab490e8f68bca0da0d0feeb9a04de + '\'>'+addy_text38dab490e8f68bca0da0d0feeb9a04de+'<\/a>';
        </script>
    ”</p>
    <p>Hopefully this saves you some frustration.</p>
    <p>Martin</p><div class="mr_social_sharing_wrapper"><span class="mr_social_sharing"><span class="mr_social_sharing"></span></span></div></div></div><p><strong>Read more</strong>&nbsp;<a class="rssreadon" rel="external" title="Adding a vRO PowerShell Host – Kerberos Configurat" href="http://www.valcolabs.com/2015/09/30/adding-a-vro-powershell-host-kerberos-configuration/" >http://www.valcolabs.com/2015/09/30/adding-a-vro-powershell-host-kerberos-configuration/</a></p>
<div id="copyright">&copy;2021 Dantastic Dot Org | Powered by whiskey and apathy</div>
@endsection
