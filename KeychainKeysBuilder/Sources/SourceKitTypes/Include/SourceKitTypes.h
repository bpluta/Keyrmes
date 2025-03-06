//
//  SourceKitTypes.h
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

#ifndef SOURCEKIT_TYPES
#define SOURCEKIT_TYPES

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

typedef struct {
  uint64_t data[3];
} sourcekitd_variant_t;

typedef struct sourcekitd_uid_s *sourcekitd_uid_t;
typedef void *sourcekitd_object_t;
typedef void *sourcekitd_response_t;

typedef bool (*sourcekitd_variant_dictionary_applier_f_t)(sourcekitd_uid_t key, sourcekitd_variant_t value, void *context);
typedef bool (*sourcekitd_variant_array_applier_f_t)(size_t index, sourcekitd_variant_t value, void *context);

#endif
