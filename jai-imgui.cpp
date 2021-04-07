// config
#define IMGUI_DISABLE_OBSOLETE_FUNCTIONS
#define IMGUI_DISABLE_DEFAULT_ALLOCATORS
#define IMGUI_USE_BGRA_PACKED_COLOR

#ifndef JAI_IMGUI_BUILDING_IMPLEMENTATION
// Just include the headers for the bindings generator.
#include "imgui.h"

// Save some preprocessor values for Jai
namespace Preprocessor_Defines {
    const bool USE_BGRA_PACKED_COLOR =
        #ifdef IMGUI_USE_BGRA_PACKED_COLOR
            true;
        #else
            false;
        #endif
}
#else
// Building the libraries.
#include "imgui.cpp"
#include "imgui_demo.cpp"
#include "imgui_draw.cpp"
#include "imgui_widgets.cpp"
#include "imgui_tables.cpp"
#endif

