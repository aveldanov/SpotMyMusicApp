//
//  AuthResponse.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String
    let scope: String
    let token_type: String
}

/*
"access_token" = "BQDRfrIgtGTkVH6uCxS_ec1WpPFkLEfVl6drmUe6KlFGUllfNDK1OFUWcqicsLd3Rb54k0Ua6j3JfEYG-Q5FPSLqsMCx4k_qXEzkaOmPPuStyHCSP62F9NVJzwj6-hDm4I5bKEkAUSVUbQ889Wpl-BlNDiKsBQhXRRMXbglvKfLnxe02Vgk";
"expires_in" = 3600;
"refresh_token" = "AQBkleuI2tO0ASw7xIZxKZE0C9Fw-fQ36heZjuwAwR17yPhUJAETrjO2qzaN-GT7jQd5DI272f58R0rInF41dNextbfyDPzPu508CMtwnK5FTG-Ssqf-Bv5GCODLPEw3FF4";
scope = "user-read-private";
"token_type" = Bearer;

 
