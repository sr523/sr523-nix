{ ... }:

# Cornell CU VPN (Cisco Secure Client) profile seeding.
#
# Cisco Secure Client cannot be installed declaratively: it is not available as
# a Homebrew cask and its installer is gated behind Cornell's NetID + Duo login
# (https://cuvpn.cuvpn.cornell.edu, or downloads.cornell.edu/vpn). So the client
# itself is a one-time manual install — see README.md ("Cornell CU VPN").
#
# What we CAN make reproducible is the connection profile. The client reads XML
# profiles from /opt/cisco/secureclient/vpn/profile/ and offers each HostEntry
# in its connection dropdown. This module writes a profile pointing at
# cuvpn.cuvpn.cornell.edu so the connection is preconfigured after a rebuild.
#
# The profile dir is root-owned and lives outside $HOME, so this runs as a
# root-level nix-darwin activation script rather than a home-manager one. It is
# a no-op (with a hint) until the Cisco Secure Client is actually installed.
let
  profile = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <AnyConnectProfile xmlns="http://schemas.xmlsoap.org/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.xmlsoap.org/encoding/ AnyConnectProfile.xsd">
    	<ClientInitialization>
    		<UseStartBeforeLogon UserControllable="true">false</UseStartBeforeLogon>
    		<AutomaticCertSelection UserControllable="true">true</AutomaticCertSelection>
    		<ShowPreConnectMessage>false</ShowPreConnectMessage>
    		<CertificateStore>All</CertificateStore>
    		<CertificateStoreMac>Login</CertificateStoreMac>
    		<CertificateStoreOverride>false</CertificateStoreOverride>
    		<ProxySettings>Native</ProxySettings>
    		<AllowLocalProxyConnections>true</AllowLocalProxyConnections>
    		<AuthenticationTimeout>60</AuthenticationTimeout>
    		<AutoConnectOnStart UserControllable="true">false</AutoConnectOnStart>
    		<MinimizeOnConnect UserControllable="true">true</MinimizeOnConnect>
    		<LocalLanAccess UserControllable="true">false</LocalLanAccess>
    		<DisableCaptivePortalDetection UserControllable="true">false</DisableCaptivePortalDetection>
    		<ClearSmartcardPin UserControllable="true">true</ClearSmartcardPin>
    		<IPProtocolSupport>IPv4,IPv6</IPProtocolSupport>
    		<AutoReconnect UserControllable="false">true
    			<AutoReconnectBehavior UserControllable="false">ReconnectAfterResume</AutoReconnectBehavior>
    		</AutoReconnect>
    		<AutoUpdate UserControllable="false">true</AutoUpdate>
    		<RSASecurIDIntegration UserControllable="false">Automatic</RSASecurIDIntegration>
    		<WindowsLogonEnforcement>SingleLocalLogon</WindowsLogonEnforcement>
    		<WindowsVPNEstablishment>LocalUsersOnly</WindowsVPNEstablishment>
    		<AutomaticVPNPolicy>false</AutomaticVPNPolicy>
    		<PPPExclusion UserControllable="false">Disable
    			<PPPExclusionServerIP UserControllable="false"></PPPExclusionServerIP>
    		</PPPExclusion>
    		<EnableScripting UserControllable="false">false</EnableScripting>
    		<EnableAutomaticServerSelection UserControllable="true">false
    			<AutoServerSelectionImprovement>20</AutoServerSelectionImprovement>
    			<AutoServerSelectionSuspendTime>4</AutoServerSelectionSuspendTime>
    		</EnableAutomaticServerSelection>
    		<RetainVpnOnLogoff>false
    		</RetainVpnOnLogoff>
    		<AllowManualHostInput>true</AllowManualHostInput>
    	</ClientInitialization>
    	<ServerList>
    		<HostEntry>
    			<HostName>cuvpn.cuvpn.cornell.edu</HostName>
    			<HostAddress>cuvpn.cuvpn.cornell.edu</HostAddress>
    		</HostEntry>
    	</ServerList>
    </AnyConnectProfile>
  '';
in
{
  system.activationScripts.cuvpnProfile.text = ''
    PROFILE_DIR="/opt/cisco/secureclient/vpn/profile"
    if [ -d "$PROFILE_DIR" ]; then
      echo "seeding Cornell CU VPN profile (cuvpn.cuvpn.cornell.edu)"
      cat > "$PROFILE_DIR/cuvpn.xml" <<'CUVPN_PROFILE_EOF'
${profile}CUVPN_PROFILE_EOF
      chmod 644 "$PROFILE_DIR/cuvpn.xml"
    else
      echo "Cisco Secure Client not installed; skipping CU VPN profile seed." >&2
      echo "  Install it from https://cuvpn.cuvpn.cornell.edu (see README)." >&2
    fi
  '';
}
