## Run Ursula

```
nucypher ursula run --dev --federated-only
```
It will run at http://localhost:10151

## Run Alice

```
nucypher alice run --dev --federated-only --teacher-uri localhost:10151
```
Output

```
Alice Verifying Key 0273bec9cece8f59c16cac08790bae37a4ae0081b6330159508a35b188e9625455
```
It will run at http://localhost:8151

## Run Bob

```
nucypher bob run --dev --federated-only --teacher-uri localhost:10151
```
Output

```
Bob Verifying Key 025ac3baac9514e9f73d9e436301030247ec9020f8a5813f407f4142237ed12d33
Bob Encrypting Key 0236f4ef62816bfa571a3278c0641cc97bd611cdcb14ed021ca00d9137acf12ccf
```
It will run at http://localhost:11151


-----------------------------------------------------------------------------------------------------

Alice derives public key for the policy: _nucypherHackathon_


## ============ ALICE CREATES A POLICY ========

### Request

```
Url : http://localhost:8151/derive_policy_encrypting_key/nucypherHackathon 
Method : POST
```

### Response 

```
{"result": {"policy_encrypting_key": "0263a5d072e60305ff06bafe366a8d770a53cb0ddace432b60e700a0319adf9212", "label": "nucypherHackathon"}, "version": "0.1.0-alpha.18", "duration": "0:00:00"}
```

Now run **Enrico** for this policy.

```
nucypher enrico run --policy-encrypting-key 0263a5d072e60305ff06bafe366a8d770a53cb0ddace432b60e700a0319adf9212
```

It will run at http://localhost:5151


## ============ ENRICO ENCRYPTS THE MESSAGE ========

### Request

```
Url : http://localhost:5151/encrypt_message
Method : POST
Body : {
"message": "Let us hack this hackathon!"
}
```
### Response

```
{"result": {"message_kit": "A5Yb8RAvSnZZdnNu9d6p+rdWIaHLPOssZJO/90damVCCA370M749AcJ6qEtk1u0oZOX7MLTeg01yAqsLaznF0nsWt8FnQWrUWScHNg6S/gIv6iVU0pDWNjaJTeAL7KGa8zgDUaUYwQ0itRhNZaMUZIOHpO2lVuAV1uhn8MVezECC1twWw3ce1Q4GDiCRWHVFI8uq28P1Z27FveVKwTUmRA0p32qlcu1U5+8qCpbcF1aK4C7fY9dG0yMrm+LDRFzW8tDWAgPDWNG2BDd6vFEs1b0DoXQSYET6RbeLkPZJiHW+vo+hPWSiDQru+c692UWxbhHmHAz7FsG40csSCkszUHer", "signature": "Jf+oZYXyWfi0QnwExZ9Sv93Iq5i3GMYw4XdermqEthLSLRECwf1fKseTIyien/HazPBxA9cM0HgEJipu9WKaVA=="}, "version": "0.1.0-alpha.18"}
```

## ============== ALICE GRANT ACCESS TO BOB  ========

### Request

```
Url : http://localhost:8151/grant
Method : PUT
Body : {
  "bob_encrypting_key" : "0236f4ef62816bfa571a3278c0641cc97bd611cdcb14ed021ca00d9137acf12ccf",
  "bob_verifying_key": "025ac3baac9514e9f73d9e436301030247ec9020f8a5813f407f4142237ed12d33",
  "m": 1,
  "n": 1,
  "label": "nucypherHackathon",
  "expiration" : "2019-03-19T09:21:32.794695Z"
  }
```

### Response

```
Response: {"result": {"treasure_map": "PXPuMgm0TUHGAh6OQ+C2gK+su0NAlif3L2uQvx8dkJgjtYPnNjaaF00PBd7ttydQySY4goMGS0sE5OE2/m6ZfQL9rZXxfT2oTensgxRpeRAOZjMMAMQA9Xli5AO2NG1xAAABHANRxudyYSpxKq7S1As/OjUEVv2EJcTFY7QqZXSwPcQcyQIxNuNFrseWMRjy2eLNP8HHZcaanO5qc9l2G0oDlcYZjdDqXC1kWnY3VXvnL41zbN0IfyJ89Dmk6Fp7iLRta6vcAnO+yc7Oj1nBbKwIeQuuN6SuAIG2MwFZUIo1sYjpYlRVZVjStzPiRvlBUtAFHOkIBJdWImsBCdn6l6GXwtKHg4eV/ZhHbEZ/0c2oCmgxl4pyJq91pu2T5Hj1PjxVxHmojlH333WO4Kf0z/TecimJ33CLdmJSvcAMFW/dt23TRRE3epk+KPsP4vkt2gVNREO/ytab2C6QA1sLltz69D//y9LO4D9JCiw8Z6klHk97cboig373AwRtV5xq", "policy_encrypting_key": "0263a5d072e60305ff06bafe366a8d770a53cb0ddace432b60e700a0319adf9212", "alice_verifying_key": "0273bec9cece8f59c16cac08790bae37a4ae0081b6330159508a35b188e9625455"}, "version": "0.1.0-alpha.18", "duration": "0:00:01"}
```


## ============== BOB RETRIVES THE MESSAGE  ========

### Request

```
Url : http://localhost:11151/retrieve 
Method : POST
Body : {
"label": "policy1",
"policy_encrypting_key" : "0263a5d072e60305ff06bafe366a8d770a53cb0ddace432b60e700a0319adf9212",
"alice_verifying_key" :"0273bec9cece8f59c16cac08790bae37a4ae0081b6330159508a35b188e9625455",
"message_kit":"A5Yb8RAvSnZZdnNu9d6p+rdWIaHLPOssZJO/90damVCCA370M749AcJ6qEtk1u0oZOX7MLTeg01yAqsLaznF0nsWt8FnQWrUWScHNg6S/gIv6iVU0pDWNjaJTeAL7KGa8zgDUaUYwQ0itRhNZaMUZIOHpO2lVuAV1uhn8MVezECC1twWw3ce1Q4GDiCRWHVFI8uq28P1Z27FveVKwTUmRA0p32qlcu1U5+8qCpbcF1aK4C7fY9dG0yMrm+LDRFzW8tDWAgPDWNG2BDd6vFEs1b0DoXQSYET6RbeLkPZJiHW+vo+hPWSiDQru+c692UWxbhHmHAz7FsG40csSCkszUHer"
}
```

### Response

```
Response:  {"result": {"cleartexts": ["Let us hack this hackathon!"]}, "version": "0.1.0-alpha.18", "duration": "0:00:00"}
```



