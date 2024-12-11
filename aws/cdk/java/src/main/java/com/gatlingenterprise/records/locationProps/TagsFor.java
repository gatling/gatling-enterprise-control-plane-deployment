package com.gatlingenterprise.records.locationProps;

import java.util.Map;

public record TagsFor(
    Map<String, String> instance,
    Map<String, String> volume,
    Map<String, String> networkInterface) {}
