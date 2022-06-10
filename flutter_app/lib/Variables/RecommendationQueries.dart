
class RecommendationQueries{
  static String cpuQueryByPrice="""
    query cpuQueryByPrice(\$_lt: numeric!, \$_in: [Int!]) {
  cpu(where: {_and: {release_date: {_gte: "2018-01-01"}, cpu_prices: {price: {_gte: "1", _lte: \$_lt}}, target_market_number: {_in: \$_in}}}, order_by: {cpu_prices_aggregate: {sum: {price: asc}}}) {
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
      shop
      shop_link
    }
  }
}
  """;

  static String motherboardQueryBySocket = """
  query motherboardQueryById(\$_in: [String!]) {
    motherboard(where: {cpu_socket: {_in: \$_in}}) {
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

  static String gpuQueryByPriceAndTargetMarket = """
  query gpuQuery(\$_lte: numeric!, \$_tmneq: Int!) {
    gpu(where: {gpu_prices: {_and: {price: {_gte: "1", _lte: \$_lte}}}, target_market_number: {_eq: \$_tmneq}}, order_by: {release_date: asc}) {
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
        shop
        shop_link
      }
    }
  }
  """;

  static String psuQueryByWatt = """
  query psuQuery(\$_gte: Int!) {
    power_supply(where: {power_W: {_gte: \$_gte}}) {
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

  static String storageQueryBySize = """
  query storageQuery(\$_in: [String!] = "") {
    storage(where: {_and: {size: {_in: \$_in}, storage_type: {_eq: "M2 NVME SSD"}}}) {
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
}