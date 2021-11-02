require('es6-promise').polyfill();
require('isomorphic-fetch');
const fs = require('fs');
const path = process.argv[6]
const apkSize = fs.statSync(path).size;
let readStream = fs.createReadStream(path);
let newURL = "";
const appId = process.argv[2];
const projectId = process.argv[3]
const apiKey = process.argv[4]
const apiUrl = "https://api.testproject.io/";
const uploadUrlData = {
    headers: {
        "Authorization": apiKey
    },
    method: "GET"
};
const uploadAPKData = {
    headers: {
        "cache-control": "no-cache",
        "Content-length": apkSize
    },
    method: "PUT",
    body: readStream
};
// Get an upload URL for an application
fetch(apiUrl + `v2/projects/${projectId}/applications/${appId}/file/upload-link`, uploadUrlData)
    .then(result => {
        return result.json();
    })
    .then(data => {
        newURL = data.url;
        uploadAPK();
    })
    .catch(error => {
        console.log(error);
    });
// Upload the new APK to AWS S3
async function uploadAPK() {
    fetch(newURL, uploadAPKData)
        .then(result => {
            confirmNewAPK();
        })
        .catch(error => {
            console.log(error);
        });
}
// Confirm the new file upload
async function confirmNewAPK() {
    const newFileName = process.argv[5]
    const data = {
        headers: {
            "accept": "application/json",
            "Authorization": apiKey,
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            "fileName": newFileName
        }),
        method: "POST"
    }
    fetch(apiUrl + `v2/projects/${projectId}/applications/${appId}/file`, data)
        .then(result => {
            console.log(result);
        })
        .catch(error => {
            console.log(error);
        });
}