resource "newrelic_service_level" "myservicelevelteraf" {
  for_each = var.newrelic_service_level

  guid         = each.value.guid
  name         = each.value.name
  description  = each.value.description

  events {
    account_id = var.account_id

    valid_events {
      from = each.value.from_valid
      where = each.value.where_valid
    }

    # Conditionally include good_events or bad_events
    dynamic "good_events" {
      for_each = length(try([for e in [each.value.from, each.value.where] : e if e != ""], [])) > 0 ? [1] : []
      content {
        from = try(each.value.from, each.value.from_bad)
        where = try(each.value.where, each.value.where_bad)
      }
    }

    dynamic "bad_events" {
      for_each = length(try([for e in [each.value.from_bad, each.value.where_bad] : e if e != ""], [])) > 0 ? [1] : []
      content {
        from = try(each.value.from_bad, each.value.from)
        where = try(each.value.where_bad, each.value.where)
      }
    }
  }

  objective {
    target = each.value.target

    time_window {
      rolling {
        count = each.value.count
        unit  = each.value.unit
      }
    }
  }
}
