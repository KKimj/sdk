/*
 * Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 *
 * This file has been automatically generated. Please do not edit it manually.
 * To regenerate the file, use the script "pkg/analysis_server/tool/spec/generate_files".
 */
package org.dartlang.analysis.server.protocol;

import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import com.google.dart.server.utilities.general.JsonUtilities;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

/**
 * Deprecated: the only reference to this type has been deprecated.
 *
 * A set of options controlling what kind of analysis is to be performed. If the value of a field
 * is omitted the value of the option will not be changed.
 *
 * @coverage dart.server.generated.types
 */
@SuppressWarnings("unused")
public class AnalysisOptions {

  public static final List<AnalysisOptions> EMPTY_LIST = List.of();

  /**
   * Deprecated: this feature is always enabled.
   *
   * True if the client wants to enable support for the proposed async feature.
   */
  private final Boolean enableAsync;

  /**
   * Deprecated: this feature is always enabled.
   *
   * True if the client wants to enable support for the proposed deferred loading feature.
   */
  private final Boolean enableDeferredLoading;

  /**
   * Deprecated: this feature is always enabled.
   *
   * True if the client wants to enable support for the proposed enum feature.
   */
  private final Boolean enableEnums;

  /**
   * Deprecated: this feature is always enabled.
   *
   * True if the client wants to enable support for the proposed "null aware operators" feature.
   */
  private final Boolean enableNullAwareOperators;

  /**
   * True if hints that are specific to dart2js should be generated. This option is ignored if
   * generateHints is false.
   */
  private final Boolean generateDart2jsHints;

  /**
   * True if hints should be generated as part of generating errors and warnings.
   */
  private final Boolean generateHints;

  /**
   * True if lints should be generated as part of generating errors and warnings.
   */
  private final Boolean generateLints;

  /**
   * Constructor for {@link AnalysisOptions}.
   */
  public AnalysisOptions(Boolean enableAsync, Boolean enableDeferredLoading, Boolean enableEnums, Boolean enableNullAwareOperators, Boolean generateDart2jsHints, Boolean generateHints, Boolean generateLints) {
    this.enableAsync = enableAsync;
    this.enableDeferredLoading = enableDeferredLoading;
    this.enableEnums = enableEnums;
    this.enableNullAwareOperators = enableNullAwareOperators;
    this.generateDart2jsHints = generateDart2jsHints;
    this.generateHints = generateHints;
    this.generateLints = generateLints;
  }

  @Override
  public boolean equals(Object obj) {
    if (obj instanceof AnalysisOptions other) {
      return
        Objects.equals(other.enableAsync, enableAsync) &&
        Objects.equals(other.enableDeferredLoading, enableDeferredLoading) &&
        Objects.equals(other.enableEnums, enableEnums) &&
        Objects.equals(other.enableNullAwareOperators, enableNullAwareOperators) &&
        Objects.equals(other.generateDart2jsHints, generateDart2jsHints) &&
        Objects.equals(other.generateHints, generateHints) &&
        Objects.equals(other.generateLints, generateLints);
    }
    return false;
  }

  public static AnalysisOptions fromJson(JsonObject jsonObject) {
    Boolean enableAsync = jsonObject.get("enableAsync") == null ? null : jsonObject.get("enableAsync").getAsBoolean();
    Boolean enableDeferredLoading = jsonObject.get("enableDeferredLoading") == null ? null : jsonObject.get("enableDeferredLoading").getAsBoolean();
    Boolean enableEnums = jsonObject.get("enableEnums") == null ? null : jsonObject.get("enableEnums").getAsBoolean();
    Boolean enableNullAwareOperators = jsonObject.get("enableNullAwareOperators") == null ? null : jsonObject.get("enableNullAwareOperators").getAsBoolean();
    Boolean generateDart2jsHints = jsonObject.get("generateDart2jsHints") == null ? null : jsonObject.get("generateDart2jsHints").getAsBoolean();
    Boolean generateHints = jsonObject.get("generateHints") == null ? null : jsonObject.get("generateHints").getAsBoolean();
    Boolean generateLints = jsonObject.get("generateLints") == null ? null : jsonObject.get("generateLints").getAsBoolean();
    return new AnalysisOptions(enableAsync, enableDeferredLoading, enableEnums, enableNullAwareOperators, generateDart2jsHints, generateHints, generateLints);
  }

  public static List<AnalysisOptions> fromJsonArray(JsonArray jsonArray) {
    if (jsonArray == null) {
      return EMPTY_LIST;
    }
    List<AnalysisOptions> list = new ArrayList<>(jsonArray.size());
    for (final JsonElement element : jsonArray) {
      list.add(fromJson(element.getAsJsonObject()));
    }
    return list;
  }

  /**
   * Deprecated: this feature is always enabled.
   *
   * True if the client wants to enable support for the proposed async feature.
   */
  public Boolean getEnableAsync() {
    return enableAsync;
  }

  /**
   * Deprecated: this feature is always enabled.
   *
   * True if the client wants to enable support for the proposed deferred loading feature.
   */
  public Boolean getEnableDeferredLoading() {
    return enableDeferredLoading;
  }

  /**
   * Deprecated: this feature is always enabled.
   *
   * True if the client wants to enable support for the proposed enum feature.
   */
  public Boolean getEnableEnums() {
    return enableEnums;
  }

  /**
   * Deprecated: this feature is always enabled.
   *
   * True if the client wants to enable support for the proposed "null aware operators" feature.
   */
  public Boolean getEnableNullAwareOperators() {
    return enableNullAwareOperators;
  }

  /**
   * True if hints that are specific to dart2js should be generated. This option is ignored if
   * generateHints is false.
   */
  public Boolean getGenerateDart2jsHints() {
    return generateDart2jsHints;
  }

  /**
   * True if hints should be generated as part of generating errors and warnings.
   */
  public Boolean getGenerateHints() {
    return generateHints;
  }

  /**
   * True if lints should be generated as part of generating errors and warnings.
   */
  public Boolean getGenerateLints() {
    return generateLints;
  }

  @Override
  public int hashCode() {
    return Objects.hash(
      enableAsync,
      enableDeferredLoading,
      enableEnums,
      enableNullAwareOperators,
      generateDart2jsHints,
      generateHints,
      generateLints
    );
  }

  public JsonObject toJson() {
    JsonObject jsonObject = new JsonObject();
    if (enableAsync != null) {
      jsonObject.addProperty("enableAsync", enableAsync);
    }
    if (enableDeferredLoading != null) {
      jsonObject.addProperty("enableDeferredLoading", enableDeferredLoading);
    }
    if (enableEnums != null) {
      jsonObject.addProperty("enableEnums", enableEnums);
    }
    if (enableNullAwareOperators != null) {
      jsonObject.addProperty("enableNullAwareOperators", enableNullAwareOperators);
    }
    if (generateDart2jsHints != null) {
      jsonObject.addProperty("generateDart2jsHints", generateDart2jsHints);
    }
    if (generateHints != null) {
      jsonObject.addProperty("generateHints", generateHints);
    }
    if (generateLints != null) {
      jsonObject.addProperty("generateLints", generateLints);
    }
    return jsonObject;
  }

  @Override
  public String toString() {
    StringBuilder builder = new StringBuilder();
    builder.append("[");
    builder.append("enableAsync=");
    builder.append(enableAsync);
    builder.append(", ");
    builder.append("enableDeferredLoading=");
    builder.append(enableDeferredLoading);
    builder.append(", ");
    builder.append("enableEnums=");
    builder.append(enableEnums);
    builder.append(", ");
    builder.append("enableNullAwareOperators=");
    builder.append(enableNullAwareOperators);
    builder.append(", ");
    builder.append("generateDart2jsHints=");
    builder.append(generateDart2jsHints);
    builder.append(", ");
    builder.append("generateHints=");
    builder.append(generateHints);
    builder.append(", ");
    builder.append("generateLints=");
    builder.append(generateLints);
    builder.append("]");
    return builder.toString();
  }

}
