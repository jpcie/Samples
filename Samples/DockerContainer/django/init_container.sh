#!/bin/bash
service ssh start

python manage.py runserver 0.0.0.0:8000
