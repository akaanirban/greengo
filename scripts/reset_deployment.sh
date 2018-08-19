#!/bin/bash

python greengo/greengo.py delete-topic-rule
python greengo/greengo.py pop-from-state FunctionDefinition
python greengo/greengo.py pop-from-state Lambdas
python greengo/greengo.py pop-from-state ResultS3Buckets
python greengo/greengo.py create-s3-buckets
python greengo/greengo.py create-topic-rule
python greengo/greengo.py update-deployment True True
python greengo/greengo.py deploy

