from celery import shared_task
from django.db.models import F


@shared_task
def set_price(subscription_id):
    from .models import Subscription

    subscription = Subscription.objects.filter(id=subscription_id).annotate(
        annotate_price=F('service__full_price') -
            F('service__full_price') * F('plan__discount_percent') / 100.0
).first()

    new_price = (subscription.service.full_price -
                 subscription.service.full_price * subscription.plan.discount_percent / 100)
    
    subscription.price = subscription.annotate_price
    subscription.save()
