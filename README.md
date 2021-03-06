# **Secret Management System - CredStash**

This project aims to demonstrate [`credstash`](https://github.com/fugue/credstash) tool for secret management. There is a slide for quick introduction to `credstash` [here](https://www.slideshare.net/thienan93/credstash).

In order to use `credstash` we need to provision below AWS services:
1. A master key in AWS Key Management Service (KMS), where it is stored in secure HSM-backed storage. The Master Key never leaves the KMS service.
2. A DynamoDB table used for storing credentials.
3. IAM users (5 users: admin, writer, reader, dev, and qa) and appropriate policies for each user

Follow these steps in order to spin up a credstash system.

## 1. Provisioning AWS services for `credstash`

Using terrform for automatically provision all necsessary services. Run command below:
```bash
terraform apply -var-file tfvars/demo.tfvars
```
You will see the output like below if the command ran successfully:
```bash
....
Apply complete! Resources: 33 added, 0 changed, 0 destroyed.

Outputs:

credstash_admin_access_key = AKIAIG2NDE7U2U47EC3A
credstash_admin_secret_key = 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
credstash_dev_access_key = AKIAJ5LL7KTRT5XQPUKA
credstash_dev_secret_key = 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
credstash_qa_access_key = AKIAJKH3RGGQPPGQXOPA
credstash_qa_secret_key = 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
credstash_reader_access_key = AKIAJZ524DHDPUUVNLXA
credstash_reader_secret_key = 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
credstash_writer_access_key = AKIAJVSI5YYCWLBTLG3A
credstash_writer_secret_key = eU54vhEoSVQhB2MCejosnMi4HgZPJeXvFAmG4bCj
```

## 2. Install `credstash` on your machine
- For Debian and Ubuntu, the following command will ensure that the required dependencies are installed
```bash
sudo apt-get install build-essential libssl-dev libffi-dev python-dev
```
- For Fedora and RHEL-derivatives, the following command will ensure that the required dependencies are installed:
```bash
sudo yum install gcc libffi-devel python-devel openssl-devel
```
- Install `credstash` using `pip`
```bash
sudo pip install credstash
```

## 3. Explore functionalities
### 1. Basic operations
- Create a secret: As a user (`writer`) who has write permissions, you can store a secret into `credstash` system.
```bash
$ credstash put app1.db.password 123456
app1.db.password has been stored
```
- Get a secret that already stored: As a user (`reader`) who has read permissions, you can get a secret from `credstash`
```bash
$ credstash get app1.db.password
123456
```
- Create a secret from a file: As a user (`writer`) who has write permissions, you can store a secret from file as below
```bash
$ credstash put server1.ssh_key @private_key.txt
server1.ssh_key has been stored
```
- As a user (`reader`) who has read permissions, you can get it back
```bash
$ credstash get server1.ssh_key
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA4evLerucuI/Du/tFoj3pFeGVIX9f6YpRZToYp/BHUWH7Uywv
qKm3fpJwkZGfTuHNBfkUYbZJZjOFLksTjiAXHeewLpeaLUmcUYkmz/qf8LHUTZRA
pnAgMOu9A8Nr9UH6pe+VV99OB+iPuES/q6BGoyqN7EJIBByIS4Q0t1AXCpt4Gf8o
PBB+EDcqfqzZ4gWGkl6j8hjvYQML8EDTID994v5ak7KaQvUmTKRYnrsnR6lgwz6M
FZ6YsQppRehadLfkdl/W3h4D0d5AB46AVPTbMwPAqyjB9rsOdP5SSKheY6JwSene
1Sz327/kiD0JyMEgLZPx+futwKzfS7MTVvUB9QIDAQABAoIBAGZyvfAnGbecAf/B
v18GQieZBz6Me1r1TVnhEYM+c6jVDNo3pFkQtVQhZgitB5gGzylRPUveFMTSwicv
Bmwh4zm9ceh++PxmcAuNbVtM5LCKg6K2gua22/IzRKBrQw6R3+7ViVyyt7jgXiQK
kPxsDvw49OjZWbz7j1bnWdxy5i/5XEk75XQJIt6NY0XUUZbpEJY3BB+ctUJNx9ZA
+ploT6NTtRlufbg365+rdHyLnrtM3+KX8gauT4RDXqIgcFd0/i+xY3G28TT7OwiE
nYNX4DjZaY/2ZPbBrB0dxxPyjagdfUKpQtZHzz3K8vU8wlpK0B8TclfJhZqunmcx
1His21UCgYEA81qrEECE5efcl1GXGEfoaYeqrN1lL5VGoRl1jnqpGe+AtNlnfKHv
TcXA4A603sOIVBpQndPzWaiFlDWSJa9R6kyW1sz0Cjzqz60pp3UyUKIZ3IO2trhz
xOiIBEOOddHn8x+QhdqEIwsK1jnP6yFN3sQCaV91QHOyJaZLmZMRZOMCgYEA7ak2
+O39iGWLqu6EKskqna5fbJ0dfMUjJ9AlRMgEuhyV1ymQcKdFZsGpTJRUpIGDimCf
84Xc+1tKvYANI1QfAmajY+lHGX9X3GjVhKwh/QOnzz6gTUS3XYsrxBg6PYPS/hlH
uBCKyiv4m/HubaTqkJFKnFy2Squr3ylpehr7jUcCgYEAkKQ+cs12cFQMyB/lp7ft
yvOpHVAGOW8HaO+B8Oq1IcY6AMQLf4ecfeRhTItRM+qSWDK/4d89j/fbVYk10ZJQ
JOva59cv4fntMvzgejjtbAG9T1U2P4qIvOvdFHO29A6MR/Rl6TlFOrLwgP4ht8a2
ywZDzK/BOErMAxbBbol8WDMCgYB3YUCT2jg4g4mc2yLYuyQFAMo+LM3bFsuJ/Cw8
WJzHQASkh+ReMifSbgU0ym2aFNSWdeLi2KMgP8NTXTc8P80zz4rTbSKh1C22MZLP
igeoqGVq3PJ43cOd4YKihej7bXRW3yv/cY/F7kB7VROHUAfjhpgL4yZOa91xw8OP
6m3hkQKBgEJmyrITPtXynsTa8q6qdUEM1q8JWWcPl1vH3aWkKgxfZ3aCyQ7yTohw
+KIxzD2km59q4bIK0zewk4JhnFwGffsk2HvsbcggmlP41t0ZsfEbToNRgP8lW9rY
tgcwnOamjnPlZmLk4fw8nwtLAqpajZ1JIxLMXzQkGBMq96Uccm3W
-----END RSA PRIVATE KEY-----
```
- List secrets: As a user who has read permissions, you can list secrets.
```bash
$ credstash list
app1.db.password -- version 0000000000000000001 -- comment
server1.ssh_key  -- version 0000000000000000001 -- comment
```
- Delete secrets: As a user (`admin`) who has admin permissions, you can delete secrets.
  + We will use user `writer` for demonstrate users who do not have appropriate permissions could not delete secret.
  ```bash
  $ credstash delete server1.ssh_key
  An error occurred (AccessDeniedException) when calling the Scan operation: User: arn:aws:iam::<account-id>:user credstash-writer is not authorized to perform: dynamodb:Scan on resource: arn:aws:dynamodb:<region>:<account-id>:table/credential-store
  ```
  + With user `admin`, however, we can delete a secret successfully
  ```bash
  $ credstash delete server1.ssh_key
  Deleting server1.ssh_key -- version 0000000000000000001
  $ credstash list
  app1.db.password -- version 0000000000000000001 -- comment
  ```

### 2. Versioning secrets
Secrets are stored by `credstash` are versioned and immutable. That means you cannot change value of a secret when it's already put. However, you can change the value by storing a new version of that secret by specify `-v <version>` or `-a` for automatically increase.
- As a `writer` try to change value of a secret that already put:
```bash
$ credstash put app1.db.password 1234567
app1.db.password version 0000000000000000001 is already in the credential store. Use the -v flag to specify a new version
```
Now try again with `-a` option:
```bash
$ credstash put app1.db.password 1234567 -a
app1.db.password has been stored
```
- As a `reader`, we will list secret to see versioning:
```bash
$ credstash list
app1.db.password -- version 0000000000000000001 -- comment
app1.db.password -- version 0000000000000000002 -- comment
```
Additionally, we can get value of a secret at specified version:
```bash
$ credstash get app1.db.password -v 0000000000000000001
123456
$ credstash get app1.db.password -v 0000000000000000002
1234567
```
### 3. Controlling access secrets
`credstash` has a way for constraining access to a given secret. When storing a secret, we can provide any number of **Encryption Context** key value pair to associate with the secret. The exact encryption context key value pair that were associated with the secret when it was `put` must be provided in the `get` request to successfully decrypt the secret.
- As a `writer` put a secret with encryption context:
```bash
$ credstash put app2.db.password 123456 tier=db env=dev
app2.db.password has been stored
```
- As a `reader` get that secret back
```bash
$ credstash get app2.db.password
KMS ERROR: Could not decrypt hmac key with KMS. The encryption context provided may not match the one used when the credential was stored.
```
It throws an error due to missing encryption context. Now we provide extract encryption context in oder to get the secret back.
```bash
$ credstash get app2.db.password tier=db env=dev
123456
```
**Encryption context** is great, right? But what if you want restrict someone access some secret even they know encryption context. Fortunately, it's possible with encryption context and proper configuration. Let review a scenario like below.
I have two group: devloper and tester. I want developers are able to `put` and `get` secrets with encryption context `role=dev` only. Likewise, testers are able to `put` and `get` secrets with encryption context `role=qa`
- As a `dev` put a secret without encryption context `role=dev`
```bash
$ credstash put app3.db.password 123456 tier=db env=dev
Traceback (most recent call last):
  File "/home/nthienan/.ven/bin/credstash.py", line 79, in generate_key_data
    KeyId=self.key_id, EncryptionContext=self.encryption_context, NumberOfBytes=number_of_bytes
  File "/home/nthienan/.ven/lib/python3.6/site-packages/botocore/client.py", line 357, in _api_call
    return self._make_api_call(operation_name, kwargs)
  File "/home/nthienan/.ven/lib/python3.6/site-packages/botocore/client.py", line 661, in _make_api_call
    raise error_class(parsed_response, operation_name)
botocore.exceptions.ClientError: An error occurred (AccessDeniedException) when calling the GenerateDataKey operation: User: arn:aws:iam::<account-id>:user/credstash-dev is not authorized to perform: kms:GenerateDataKey on resource: arn:aws:kms:<region>:<account-id>:key/987ac9ed-984f-44be-8076-715df7773d53
```
It fails due to missing `role=dev`. Now let's try with `role=other`
```bash
$ credstash put app3.db.password 123456 tier=db env=dev role=other
Traceback (most recent call last):
  File "/home/nthienan/.ven/bin/credstash.py", line 79, in generate_key_data
    KeyId=self.key_id, EncryptionContext=self.encryption_context, NumberOfBytes=number_of_bytes
  File "/home/nthienan/.ven/lib/python3.6/site-packages/botocore/client.py", line 357, in _api_call
    return self._make_api_call(operation_name, kwargs)
  File "/home/nthienan/.ven/lib/python3.6/site-packages/botocore/client.py", line 661, in _make_api_call
    raise error_class(parsed_response, operation_name)
botocore.exceptions.ClientError: An error occurred (AccessDeniedException) when calling the GenerateDataKey operation: User: arn:aws:iam::<account-id>:user/credstash-dev is not authorized to perform: kms:GenerateDataKey on resource: arn:aws:kms:<region>:<account-id>:key/987ac9ed-984f-44be-8076-715df7773d53
```
It's same error and that is what we expected. Let's try with `role=dev`
```bash
$ credstash put app3.db.password 123456 tier=db env=dev role=dev
app3.db.password has been stored
```
It's successful. Get that secret back.
```bash
$ credstash get app3.db.password tier=db env=dev role=dev
123456
```
- As a `qa` try to get dev secret
```bash
$ credstash get app3.db.password tier=db env=dev role=dev
KMS ERROR: Decryption error An error occurred (AccessDeniedException) when calling the Decrypt operation: The ciphertext refers to a customer master key that does not exist, does not exist in this region, or you are not allowed to access.
```
## 4. Clean up
Because we use Terraform to provision services, so you just need to run `terraform destroy` in order to clean up.
```bash
$ terraform destroy -var-file tfvars/demo.tfvars
....
Plan: 0 to add, 0 to change, 33 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
....
Destroy complete! Resources: 33 destroyed.
```
