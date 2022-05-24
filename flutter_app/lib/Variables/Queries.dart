
library flutter_app.queries;

String coolingQuery = """
query coolingQuery {
  cooling {
    id
    name
    rpm
    cfm
    dba
    cpu_height
    cooling_prices(order_by: {price: asc}, limit: 1) {
      price
      shop
    }
  }
}
""";

String coolingQueryById = """
query coolingQueryById(\$id: uuid!) {
  cooling(where: {id: {_eq: \$id}}) {
    id
    name
    rpm
    cfm
    dba
    cpu_height
    cooling_prices(order_by: {price: asc}) {
      price
      shop
      note
      shop_link
    }
  }
}
""";

String cpuQuery = """
query cpuQuery {
  cpu (where: {_and: {release_date: {_gte: "2018-01-01"}, cpu_prices: {price: {_gte: "1"}}}}, order_by: {release_date: desc}){
    id
    name
    manufacturer
    process
    socket_name
    tdp_watt
    l3_cache
    Clock
    Cores
    cpu_prices(limit: 1, order_by: {price: asc}) {
      price
    }
  }
}
""";

String cpuQueryById = """
query cpuQueryById(\$id: uuid!) {
  cpu(where: {id: {_eq: \$id}}) {
    id
    name
    manufacturer
    process
    socket_name
    tdp_watt
    l3_cache
    Clock
    Cores
    cpu_prices(order_by: {price: asc}) {
      price
      note
      shop
      shop_link
    }
  }
}
""";

String gpuQuery = """
query gpuQuery {
  gpu(where: {gpu_prices: {_and: {price: {_gte: "1"}}}}, order_by: {release_date: asc}) {
    id
    name
    gpu_chip
    gpu_clock
    interface_bus
    memory
    memory_clock
    recommended_wattage
    release_date
    gpu_prices(limit: 1, order_by: {price: asc}) {
      price
    }
  }
}
""";

String gpuQueryById = """
query gpuQueryById(\$id: uuid!) {
  gpu(where: {id: {_eq: \$id}}) {
    id
    name
    gpu_chip
    gpu_clock
    interface_bus
    memory
    memory_clock
    recommended_wattage
    release_date
    gpu_prices(order_by: {price: asc, shop: asc, shop_link: asc}) {
      price
      shop
      shop_link
    }
  }
}
""";

String motherboardQuery = """
query motherboardQuery {
  motherboard(where: {motherboard_prices: {price: {_gte: "1"}}}) {
    id
    name
    form_factor
    cpu_socket
    chipset
    ram_slot
    ram_slot_count
    release_year
    motherboard_prices(limit: 1, order_by: {price: asc}) {
      price
    }
    pcie_slots_json
    sata3_slot_count
    m2_slots_json
  }
}

""";

String motherboardQueryById = """
query motherboardQueryById(\$id: uuid!) {
  motherboard(where: {id: {_eq: \$id}}) {
    id
    name
    form_factor
    cpu_socket
    chipset
    ram_slot
    ram_slot_count
    release_year
    motherboard_prices(limit: 1, order_by: {price: asc}) {
      price
      shop_link
      shop
    }
    pcie_slots_json
    sata3_slot_count
    m2_slots_json
  }
}
""";

String psuQuery = """
query psuQuery {
  power_supply {
    id
    name
    power_W
    efficiency
    power_supply_prices(limit: 1, order_by: {price: asc}) {
      price
    }
  }
}
""";

String psuQueryById = """
query psuQueryById(\$id:uuid!) {
  power_supply(where: {id: {_eq: \$id}}) {
    id
    name
    power_W
    efficiency
    power_supply_prices(order_by: {price: asc}) {
      price
      shop
      shop_link
    }
  }
}
""";

String ramQuery = """
query ramQuery {
  ram {
    id
    name
    size_gb
    ram_slot
    ram_frequency_mhz
    ram_prices(limit: 1, order_by: {price: asc}) {
      price
    }
  }
}
""";

String ramQueryById = """
query ramQueryById (\$id: uuid!){
  ram(where: {id: {_eq: \$id}}) {
    id
    name
    size_gb
    ram_slot
    ram_frequency_mhz
    ram_prices(order_by: {price: asc}) {
      price
      shop
      shop_link
      sell_count
    }
  }
}

""";

String storageQuery = """
query storageQuery {
  storage {
    id
    name
    interface_bus
    quality_index
    size
    storage_type
    storage_prices(limit: 1, order_by: {price: asc}) {
      price
    }
  }
}
""";

String storageQueryById = """
query storageQueryById(\$id:uuid!) {
  storage(where: {id: {_eq: \$id}}) {
    id
    name
    interface_bus
    quality_index
    size
    storage_type
    storage_prices(order_by: {price: asc}) {
      price
      shop
      shop_link
      name
    }
  }
}

""";