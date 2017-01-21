# Swagg-lp

## Requirements

You must have ```docker``` and ```docker-compose``` installed in order to use Swagg-lp.

## Configuration

First, clone the project :

```
git clone https://github.com/juliettegonzalez/swagg-lp.git
cd swagg-lp
```

Then create some usefull repositories :

```
mkdir output
mkdir scripts
```

Swagg-lp comes with a generated Swagger documentation in the ```doc``` folder. Of course, you can change the content of the ```doc``` folder as you will.

## Flexible Parameters Generation

It may appear that you need for some reason to generate parameters value not in a random way. You can write some scripts to generate parameters and use the tag feature to link the value returned by scripts to your parameters. For instance:

In the Swagger documentation of your API :
```json
{
    "paramType": "query",
    "name": "token",
    "description": "This is the session token for the request",
    "dataType": "string",
    "type": "string",
    "format": "",
    "allowMultiple": false,
    "required": true,
    "minimum": 0,
    "maximum": 0
}
```

Just add an # with a key word. For instance:
```json
{
    "paramType": "query",
    "name": "token",
    "description": "This is the session token for the request #sessiontoken",
    "dataType": "string",
    "type": "string",
    "format": "",
    "allowMultiple": false,
    "required": true,
    "minimum": 0,
    "maximum": 0
}
```

Then, in the ```scripts``` folder, write a script to generate a ```sessiontoken``` (you can either use ```Ruby``` or ```Bash``` script). Create a ```sessiontoken.sh``` for example and write a script that will output the value of your parameter. It could be as simple as :

```bash
echo "my_fixed_parameter_value"
```

This script will be executed everytime Swagg-lp will meet a parameter with the ```#sessiontoken``` in its description.

After that, you need to link the hashtag keyword to the script in the ```config.yml``` file:

```yml
tags:
    "insapptoken": "usertoken.rb"
    #...
```

## Configuration File

In the configuration you have to list every json files of your swagger documentation you want to parse in order to execute Fuzzy Tests (use relative path from the ```doc``` folder):

```yml
docs:
    - association/index.json
    - event/index.json
    - notification/index.json
    - post/index.json
    - report/index.json
    - search/index.json
    - user/index.json
```

Then you can specify the class for each HTTP status code (either Warning, Success or Error):

```
codes:
    warning:
        - 401
    error:
        - 200
        - 500
        - 502
    success:
        - 400
        - 403
        - 404
        - 406
```

Then, specify the root of the URL to access the generated HTML output files:

```yml
log_server:
    url: http://localhost:9000/
```

Finally, add the ```tags``` section. You should have something that looks like:

```
docs:
    - association/index.json
    - event/index.json
    - notification/index.json
    - post/index.json
    - report/index.json
    - search/index.json
    - user/index.json
codes:
    warning:
        - 401
    error:
        - 200
        - 500
        - 502
    success:
        - 400
        - 403
        - 404
        - 406
log_server:
    url: http://localhost:9000/
tags:
    "insapptoken": "usertoken.rb"
```

## Run the Tests

Then you just have to use

```bash
docker-compose up --build
```

If you want to get the exit code you should use the following hack:

```bash
docker-compose up --build ; [ $(docker inspect swagglp_swagglp_1 | grep '"ExitCode": 0,' | wc -l) = 1]
```
