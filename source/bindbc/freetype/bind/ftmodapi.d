
//          Copyright 2019 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftmodapi;

import bindbc.freetype.config;
import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.ftsystem,
       bindbc.freetype.bind.fttypes;

enum {
    FT_MODULE_FONT_DRIVER       = 1,
    FT_MODULE_RENDERER          = 2,
    FT_MODULE_HINTER            = 4,
    FT_MODULE_STYLER            = 8,
    FT_MODULE_DRIVER_SCALABLE   = 0x100,
    FT_MODULE_DRIVER_NO_OUTLINES= 0x200,
    FT_MODULE_DRIVER_HAS_HINTER = 0x400,
    FT_MODULE_DRIVER_HINTS_LIGHTLY = 0x800,
}

alias FT_Module_Interface = FT_Pointer;

extern(C) nothrow {
    alias FT_Module_Constructor = FT_Error function(FT_Module);
    alias FT_Module_Destructor = void function(FT_Module);
    alias FT_Module_Requester = FT_Module_Interface function(FT_Module, const(char)*);
}

struct FT_Module_Class {
    FT_ULong module_flags;
    FT_Long module_size;
    FT_String* module_name;
    FT_Fixed module_version;
    FT_Fixed module_requires;
    void* module_interface;
    FT_Module_Constructor module_init;
    FT_Module_Destructor module_done;
    FT_Module_Requester get_interface;
}

static if((ftSupport == FTSupport.ft210 && FREETYPE_PATCH > 0) || ftSupport > FTSupport.ft210)
    extern(C) nothrow alias FT_DebugHook_Func = FT_Error function(void*);
else
    extern(C) nothrow alias FT_DebugHook_Func = void function(void*);

alias FT_TrueTypeEngineType = int;
enum {
    FT_TRUETYPE_ENGINE_TYPE_NONE = 0,
    FT_TRUETYPE_ENGINE_TYPE_UNPATENTED,
    FT_TRUETYPE_ENGINE_TYPE_PATENTED
}

static if(staticBinding) {
	extern(C) @nogc nothrow {
        FT_Error FT_Add_Module(FT_Library library, const(FT_Module_Class)* clazz);
        FT_Module FT_Get_Module(FT_Library library, const(char)* module_name);
        FT_Error FT_Remove_Module(FT_Library library, FT_Module module_);
        FT_Error FT_Property_Set(FT_Library library, const(FT_String)* module_name, const(FT_String)* property_name, const(void)* value);
        FT_Error FT_Property_Get(FT_Library library, const(FT_String)* module_name, const(FT_String)* property_name, void* value);
        FT_Error FT_Reference_Library(FT_Library library);
        FT_Error FT_New_Library(FT_Memory memory, FT_Library* alibrary);
        FT_Error FT_Done_Library(FT_Library library);
        void FT_Set_Debug_Hook(FT_Library library, FT_UInt hook_index, FT_DebugHook_Func debug_hook);
        void FT_Add_Default_Modules(FT_Library library);
        FT_TrueTypeEngineType FT_Get_TrueType_Engine_Type(FT_Library library);

        static if(ftSupport >= FTSupport.ft28) {
            void FT_Set_Default_Properties(FT_Library library);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Add_Module = FT_Error function(FT_Library library, const(FT_Module_Class)* clazz);
        alias pFT_Get_Module = FT_Module function(FT_Library library, const(char)* module_name);
        alias pFT_Remove_Module = FT_Error function(FT_Library library, FT_Module module_);
        alias pFT_Property_Set = FT_Error function(FT_Library library, const(FT_String)* module_name, const(FT_String)* property_name, const(void)* value);
        alias pFT_Property_Get = FT_Error function(FT_Library library, const(FT_String)* module_name, const(FT_String)* property_name, void* value);
        alias pFT_Reference_Library = FT_Error function(FT_Library library);
        alias pFT_New_Library = FT_Error function(FT_Memory memory, FT_Library* alibrary);
        alias pFT_Done_Library = FT_Error function(FT_Library library);
        alias pFT_Set_Debug_Hook = void function(FT_Library library, FT_UInt hook_index, FT_DebugHook_Func debug_hook);
        alias pFT_Add_Default_Modules = void function(FT_Library library);
        alias pFT_Get_TrueType_Engine_Type = FT_TrueTypeEngineType function(FT_Library library);

        static if(ftSupport >= FTSupport.ft28) {
            alias pFT_Set_Default_Properties = void function(FT_Library library);
        }
    }

    __gshared {
        pFT_Add_Module FT_Add_Module;
        pFT_Get_Module FT_Get_Module;
        pFT_Remove_Module FT_Remove_Module;
        pFT_Property_Set FT_Property_Set;
        pFT_Property_Get FT_Property_Get;
        pFT_Reference_Library FT_Reference_Library;
        pFT_New_Library FT_New_Library;
        pFT_Done_Library FT_Done_Library;
        pFT_Set_Debug_Hook FT_Set_Debug_Hook;
        pFT_Add_Default_Modules FT_Add_Default_Modules;
        pFT_Get_TrueType_Engine_Type FT_Get_TrueType_Engine_Type;

        static if(ftSupport >= FTSupport.ft28) {
            pFT_Set_Default_Properties FT_Set_Default_Properties;
        }
    }
}