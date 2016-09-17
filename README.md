# Artifactory Resource

Versions objects in artifactory using the [jfrog cli](https://github.com/JFrogDev/jfrog-cli-go).

## Source Configuration

* `url`: *Required.* The url of the artifactory server

* `repo`: *Required.* The name of the repo in artifactory. 

* `user`: *Optional.* The artifactory user

* `password`: *Optional.* The artifactory password

* `apikey`: *Optional.* The artifactory api key

* `ssh-key`: *Optional.* The SSH key file when authenticating with RSA keys

* `regexp`: *Optional.* The pattern to match filenames against within artifactory. The first grouped match is used to extract the version, or if a group is explicitly named `version`, that group is used. At least one capture group must be specified, with parentheses then you can keep the file name the same and upload new versions of your file without resorting to version numbers. This property is the path to the file in your artifactory repo. 

## Behavior

### `check`: Extract versions from the bucket.

Objects will be found via the pattern configured by `regexp`. The versions
will be used to order them (using [semver](http://semver.org/)). Each
object's filename is the resulting version.


### `in`: Fetch an object from the bucket.

Places the following files in the destination:

* `(filename)`: The file fetched from the bucket.

* `url`: A file containing the URL of the object. If `private` is true, this
  URL will be signed.

* `version`: The version identified in the file name.

#### Parameters

*None.*


### `out`: Upload an object to the bucket.

Given a file specified by `file`, upload it to the artifactory repo. The new file will be uploaded to the directory that the regex searches in. 

#### Parameters

* `file`: *Required.* Path to the file to upload, provided by an output of a task.
  If multiple files are matched by the glob, an error is raised. The file which
  matches will be placed into the directory structure on artifactory as defined in `regexp`
  in the resource definition. The matching syntax is bash glob expansion, so
  no capture groups, etc.


## Example Configuration

### Resource Type

You have to add the resource type. 

``` yaml
resource_types:
- name: artifactory
  type: docker-image
  source:
    repository: nkcraddock/concourse-artifactory-resource
    tag: latest
```
### Resource

``` yaml
- name: release
  type: artifactory
  source:
    url: https://my-artifactory-server
    repo: my-company-release
    regexp: my-app/my-app-(.*).tgz
    user: ARTIFACTORY_USER
    password: ARTIFACTORY_PASSWORD
```

### Plan

``` yaml
- get: release
```

``` yaml
- put: release
  params:
    file: path/to/my-app-*.tgz
```

# License

Copyright 2016 Ultimate Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
