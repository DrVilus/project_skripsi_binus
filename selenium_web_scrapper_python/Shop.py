import decimal
import uuid
from typing import TypedDict


class Shop(TypedDict):
    id: str
    storage_id: str
    psu_id: str
    ram_id: str
    cpu_id: str
    gpu_id: str
    name: str
    shop: str
    shop_link: str
    price: float
