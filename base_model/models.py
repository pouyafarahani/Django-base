from django.db import models
from django.utils import timezone


class BaseModel(models.Model):
    time_create = models.DateTimeField(default=timezone.now)
    time_update = models.DateTimeField(auto_now=True)
