# Artifactory Resource

Versions objects in artifactory using the [jfrog cli](https://github.com/JFrogDev/jfrog-cli-go).

## Source Configuration

* `url`: *Required.* The url of the artifactory server

* `path`: *Required.* The path to the directory in artifactory

* `user`: *Required.* The artifactory user

* `password`: *Required.* The artifactory password

* `regexp`: *Required.* The regular expression to match the file. Note: There must be a capture group that will match the semver in the filename. 

## Behavior

### `check`: Extract versions from the bucket.

Objects will be found via the pattern configured by `regexp`. The versions
will be used to order them (using [semver](http://semver.org/)). Each
object's filename is the resulting version.


### `in`: Fetch an object from the bucket.

Places the following files in the destination:

* `(filename)`: The file fetched from the bucket.

#### Parameters

* `explode`: *Optional.* If `true`, the downloaded file will be untarred. (Defaults to `false)

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
    path: repo/my-app
		regexp: my-app-(.*).tgz
    user: ARTIFACTORY_USER
    password: ARTIFACTORY_PASSWORD
```

### Plan

``` yaml
- get: release
	params: { explode: true }
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
