/**
 * @author paulk@nebulaconsulting.co.uk
 * @date 01/11/2024
 * @description Creates an external credential and a named credential, with the same name and developer name.
 */
public with sharing class CreateExternalCredential {

    public static void createCredential(String name, String devName, String urlEndpoint) {

        createExternalCredential(name, devName);
        createNamedCredential(name, devName, urlEndpoint);
    }

    private static void createExternalCredential(String name, String devName) {
        ConnectApi.ExternalCredentialInput newExternalCredential = new ConnectApi.ExternalCredentialInput();
        newExternalCredential.developerName = devName;
        newExternalCredential.masterLabel = name;

        // Creates a Custom authentication protocol named principal
        newExternalCredential.authenticationProtocol = ConnectApi.CredentialAuthenticationProtocol.Custom;

        ConnectApi.ExternalCredentialPrincipalInput newExternalCredentialPrincipal = new ConnectApi.ExternalCredentialPrincipalInput();
        newExternalCredentialPrincipal.sequenceNumber = 1;
        newExternalCredentialPrincipal.principalType = ConnectApi.CredentialPrincipalType.NamedPrincipal;
        newExternalCredentialPrincipal.principalName = 'API User';

        newExternalCredential.principals = new List<ConnectApi.ExternalCredentialPrincipalInput>{
            newExternalCredentialPrincipal
        };

        ConnectApi.NamedCredentials.createExternalCredential(newExternalCredential);
    }
    private static void createNamedCredential(String name, String devName, String urlEndpoint) {
        ConnectApi.NamedCredentialInput namedCredentialInput = new ConnectApi.NamedCredentialInput();
        namedCredentialInput.masterLabel = name;
        namedCredentialInput.developerName = devName;
        namedCredentialInput.type = ConnectApi.NamedCredentialType.SecuredEndpoint;
        namedCredentialInput.calloutUrl = urlEndpoint;

        ConnectApi.ExternalCredentialInput externalCredentialInput = new ConnectApi.ExternalCredentialInput();
        externalCredentialInput.developerName = devName;
        namedCredentialInput.externalCredentials = new List<ConnectApi.ExternalCredentialInput>{
            externalCredentialInput
        };

        ConnectApi.NamedCredentialCalloutOptionsInput calloutOptionsInput = new ConnectApi.NamedCredentialCalloutOptionsInput();
        calloutOptionsInput.generateAuthorizationHeader = false;
        calloutOptionsInput.allowMergeFieldsInBody = false;
        calloutOptionsInput.allowMergeFieldsInHeader = true;

        namedCredentialInput.calloutOptions = calloutOptionsInput;

        ConnectApi.NamedCredentials.createNamedCredential(namedCredentialInput);
    }

}