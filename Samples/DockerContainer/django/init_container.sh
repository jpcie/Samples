#!/bin/bash
service ssh start
find / -name manage.py
python manage.py runserver 0.0.0.0:8000
