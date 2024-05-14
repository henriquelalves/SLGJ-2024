#pragma once

#include "s7/s7.h"

/// Defines an enum in s7 with the same name and value as in C
#define S7_DEFINE_ENUM(s7, x) \
  s7_define_variable(s7, #x, s7_make_integer(s7, x))

void rl_register_enums(s7_scheme *s7);
