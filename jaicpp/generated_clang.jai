libclang :: #foreign_library "libclang";
using CXErrorCode :: enum u32 {
        CXError_Success :: 0;
        CXError_Failure :: 1;
        CXError_Crashed :: 2;
        CXError_InvalidArguments :: 3;
        CXError_ASTReadError :: 4;
}

anon_struct_0 :: struct {
    data: *void;
    private_flags: u32;
}

CXString :: anon_struct_0;

anon_struct_1 :: struct {
    Strings: *CXString;
    Count: u32;
}

CXStringSet :: anon_struct_1;

clang_getCString :: (string: CXString) -> *u8 #foreign libclang;

clang_disposeString :: (string: CXString) -> void #foreign libclang;

clang_disposeStringSet :: (set: *CXStringSet) -> void #foreign libclang;

clang_getBuildSessionTimestamp :: () -> u64 #foreign libclang;

CXVirtualFileOverlayImpl :: struct {
}

CXVirtualFileOverlay :: *CXVirtualFileOverlayImpl;

clang_VirtualFileOverlay_create :: (options: u32) -> CXVirtualFileOverlay #foreign libclang;

clang_VirtualFileOverlay_addFileMapping :: (unk0: CXVirtualFileOverlay, virtualPath: *u8, realPath: *u8) -> CXErrorCode #foreign libclang;

clang_VirtualFileOverlay_setCaseSensitivity :: (unk0: CXVirtualFileOverlay, caseSensitive: s32) -> CXErrorCode #foreign libclang;

clang_VirtualFileOverlay_writeToBuffer :: (unk0: CXVirtualFileOverlay, options: u32, out_buffer_ptr: **u8, out_buffer_size: *u32) -> CXErrorCode #foreign libclang;

clang_free :: (buffer: *void) -> void #foreign libclang;

clang_VirtualFileOverlay_dispose :: (unk0: CXVirtualFileOverlay) -> void #foreign libclang;

CXModuleMapDescriptorImpl :: struct {
}

CXModuleMapDescriptor :: *CXModuleMapDescriptorImpl;

clang_ModuleMapDescriptor_create :: (options: u32) -> CXModuleMapDescriptor #foreign libclang;

clang_ModuleMapDescriptor_setFrameworkModuleName :: (unk0: CXModuleMapDescriptor, name: *u8) -> CXErrorCode #foreign libclang;

clang_ModuleMapDescriptor_setUmbrellaHeader :: (unk0: CXModuleMapDescriptor, name: *u8) -> CXErrorCode #foreign libclang;

clang_ModuleMapDescriptor_writeToBuffer :: (unk0: CXModuleMapDescriptor, options: u32, out_buffer_ptr: **u8, out_buffer_size: *u32) -> CXErrorCode #foreign libclang;

clang_ModuleMapDescriptor_dispose :: (unk0: CXModuleMapDescriptor) -> void #foreign libclang;

CXIndex :: *void;

CXTargetInfoImpl :: struct {
}

CXTargetInfo :: *CXTargetInfoImpl;

CXTranslationUnitImpl :: struct {
}

CXTranslationUnit :: *CXTranslationUnitImpl;

CXClientData :: *void;

CXUnsavedFile :: struct {
    Filename: *u8;
    Contents: *u8;
    Length: u64;
}

using CXAvailabilityKind :: enum u32 {
        CXAvailability_Available :: 0;
        CXAvailability_Deprecated :: 1;
        CXAvailability_NotAvailable :: 2;
        CXAvailability_NotAccessible :: 3;
}

CXVersion :: struct {
    Major: s32;
    Minor: s32;
    Subminor: s32;
}



using CXCursor_ExceptionSpecificationKind :: enum u32 {
        CXCursor_ExceptionSpecificationKind_None :: 0;
        CXCursor_ExceptionSpecificationKind_DynamicNone :: 1;
        CXCursor_ExceptionSpecificationKind_Dynamic :: 2;
        CXCursor_ExceptionSpecificationKind_MSAny :: 3;
        CXCursor_ExceptionSpecificationKind_BasicNoexcept :: 4;
        CXCursor_ExceptionSpecificationKind_ComputedNoexcept :: 5;
        CXCursor_ExceptionSpecificationKind_Unevaluated :: 6;
        CXCursor_ExceptionSpecificationKind_Uninstantiated :: 7;
        CXCursor_ExceptionSpecificationKind_Unparsed :: 8;
}

clang_createIndex :: (excludeDeclarationsFromPCH: s32, displayDiagnostics: s32) -> CXIndex #foreign libclang;

clang_disposeIndex :: (index: CXIndex) -> void #foreign libclang;

using anon_enum_2 :: enum u32 {
        CXGlobalOpt_None :: 0;
        CXGlobalOpt_ThreadBackgroundPriorityForIndexing :: 1;
        CXGlobalOpt_ThreadBackgroundPriorityForEditing :: 2;
        CXGlobalOpt_ThreadBackgroundPriorityForAll :: 3;
}

CXGlobalOptFlags :: anon_enum_2;

clang_CXIndex_setGlobalOptions :: (unk0: CXIndex, options: u32) -> void #foreign libclang;

clang_CXIndex_getGlobalOptions :: (unk0: CXIndex) -> u32 #foreign libclang;

clang_CXIndex_setInvocationEmissionPathOption :: (unk0: CXIndex, Path: *u8) -> void #foreign libclang;

CXFile :: *void;

clang_getFileName :: (SFile: CXFile) -> CXString #foreign libclang;

clang_getFileTime :: (SFile: CXFile) -> time_t #foreign libclang;

anon_struct_3 :: struct {
    data: [3] u64;
}

CXFileUniqueID :: anon_struct_3;

clang_getFileUniqueID :: (file: CXFile, outID: *CXFileUniqueID) -> s32 #foreign libclang;

clang_isFileMultipleIncludeGuarded :: (tu: CXTranslationUnit, file: CXFile) -> u32 #foreign libclang;

clang_getFile :: (tu: CXTranslationUnit, file_name: *u8) -> CXFile #foreign libclang;

clang_getFileContents :: (tu: CXTranslationUnit, file: CXFile, size: *size_t) -> *u8 #foreign libclang;

clang_File_isEqual :: (file1: CXFile, file2: CXFile) -> s32 #foreign libclang;

clang_File_tryGetRealPathName :: (file: CXFile) -> CXString #foreign libclang;

anon_struct_4 :: struct {
    ptr_data: [2] *void;
    int_data: u32;
}

CXSourceLocation :: anon_struct_4;

anon_struct_5 :: struct {
    ptr_data: [2] *void;
    begin_int_data: u32;
    end_int_data: u32;
}

CXSourceRange :: anon_struct_5;

clang_getNullLocation :: () -> CXSourceLocation #foreign libclang;

clang_equalLocations :: (loc1: CXSourceLocation, loc2: CXSourceLocation) -> u32 #foreign libclang;

clang_getLocation :: (tu: CXTranslationUnit, file: CXFile, line: u32, column: u32) -> CXSourceLocation #foreign libclang;

clang_getLocationForOffset :: (tu: CXTranslationUnit, file: CXFile, offset: u32) -> CXSourceLocation #foreign libclang;

clang_Location_isInSystemHeader :: (location: CXSourceLocation) -> s32 #foreign libclang;

clang_Location_isFromMainFile :: (location: CXSourceLocation) -> s32 #foreign libclang;

clang_getNullRange :: () -> CXSourceRange #foreign libclang;

clang_getRange :: (begin: CXSourceLocation, end: CXSourceLocation) -> CXSourceRange #foreign libclang;

clang_equalRanges :: (range1: CXSourceRange, range2: CXSourceRange) -> u32 #foreign libclang;

clang_Range_isNull :: (range: CXSourceRange) -> s32 #foreign libclang;

clang_getExpansionLocation :: (location: CXSourceLocation, file: *CXFile, line: *u32, column: *u32, offset: *u32) -> void #foreign libclang;

clang_getPresumedLocation :: (location: CXSourceLocation, filename: *CXString, line: *u32, column: *u32) -> void #foreign libclang;

clang_getInstantiationLocation :: (location: CXSourceLocation, file: *CXFile, line: *u32, column: *u32, offset: *u32) -> void #foreign libclang;

clang_getSpellingLocation :: (location: CXSourceLocation, file: *CXFile, line: *u32, column: *u32, offset: *u32) -> void #foreign libclang;

clang_getFileLocation :: (location: CXSourceLocation, file: *CXFile, line: *u32, column: *u32, offset: *u32) -> void #foreign libclang;

clang_getRangeStart :: (range: CXSourceRange) -> CXSourceLocation #foreign libclang;

clang_getRangeEnd :: (range: CXSourceRange) -> CXSourceLocation #foreign libclang;

anon_struct_6 :: struct {
    count: u32;
    ranges: *CXSourceRange;
}

CXSourceRangeList :: anon_struct_6;

clang_getSkippedRanges :: (tu: CXTranslationUnit, file: CXFile) -> *CXSourceRangeList #foreign libclang;

clang_getAllSkippedRanges :: (tu: CXTranslationUnit) -> *CXSourceRangeList #foreign libclang;

clang_disposeSourceRangeList :: (ranges: *CXSourceRangeList) -> void #foreign libclang;

using CXDiagnosticSeverity :: enum u32 {
        CXDiagnostic_Ignored :: 0;
        CXDiagnostic_Note :: 1;
        CXDiagnostic_Warning :: 2;
        CXDiagnostic_Error :: 3;
        CXDiagnostic_Fatal :: 4;
}

CXDiagnostic :: *void;

CXDiagnosticSet :: *void;

clang_getNumDiagnosticsInSet :: (Diags: CXDiagnosticSet) -> u32 #foreign libclang;

clang_getDiagnosticInSet :: (Diags: CXDiagnosticSet, Index: u32) -> CXDiagnostic #foreign libclang;

using CXLoadDiag_Error :: enum u32 {
        CXLoadDiag_None :: 0;
        CXLoadDiag_Unknown :: 1;
        CXLoadDiag_CannotLoad :: 2;
        CXLoadDiag_InvalidFile :: 3;
}

clang_loadDiagnostics :: (file: *u8, error: *CXLoadDiag_Error, errorString: *CXString) -> CXDiagnosticSet #foreign libclang;

clang_disposeDiagnosticSet :: (Diags: CXDiagnosticSet) -> void #foreign libclang;

clang_getChildDiagnostics :: (D: CXDiagnostic) -> CXDiagnosticSet #foreign libclang;

clang_getNumDiagnostics :: (Unit: CXTranslationUnit) -> u32 #foreign libclang;

clang_getDiagnostic :: (Unit: CXTranslationUnit, Index: u32) -> CXDiagnostic #foreign libclang;

clang_getDiagnosticSetFromTU :: (Unit: CXTranslationUnit) -> CXDiagnosticSet #foreign libclang;

clang_disposeDiagnostic :: (Diagnostic: CXDiagnostic) -> void #foreign libclang;

using CXDiagnosticDisplayOptions :: enum u32 {
        CXDiagnostic_DisplaySourceLocation :: 1;
        CXDiagnostic_DisplayColumn :: 2;
        CXDiagnostic_DisplaySourceRanges :: 4;
        CXDiagnostic_DisplayOption :: 8;
        CXDiagnostic_DisplayCategoryId :: 16;
        CXDiagnostic_DisplayCategoryName :: 32;
}

clang_formatDiagnostic :: (Diagnostic: CXDiagnostic, Options: u32) -> CXString #foreign libclang;

clang_defaultDiagnosticDisplayOptions :: () -> u32 #foreign libclang;

clang_getDiagnosticSeverity :: (unk0: CXDiagnostic) -> CXDiagnosticSeverity #foreign libclang;

clang_getDiagnosticLocation :: (unk0: CXDiagnostic) -> CXSourceLocation #foreign libclang;

clang_getDiagnosticSpelling :: (unk0: CXDiagnostic) -> CXString #foreign libclang;

clang_getDiagnosticOption :: (Diag: CXDiagnostic, Disable: *CXString) -> CXString #foreign libclang;

clang_getDiagnosticCategory :: (unk0: CXDiagnostic) -> u32 #foreign libclang;

clang_getDiagnosticCategoryName :: (Category: u32) -> CXString #foreign libclang;

clang_getDiagnosticCategoryText :: (unk0: CXDiagnostic) -> CXString #foreign libclang;

clang_getDiagnosticNumRanges :: (unk0: CXDiagnostic) -> u32 #foreign libclang;

clang_getDiagnosticRange :: (Diagnostic: CXDiagnostic, Range: u32) -> CXSourceRange #foreign libclang;

clang_getDiagnosticNumFixIts :: (Diagnostic: CXDiagnostic) -> u32 #foreign libclang;

clang_getDiagnosticFixIt :: (Diagnostic: CXDiagnostic, FixIt: u32, ReplacementRange: *CXSourceRange) -> CXString #foreign libclang;

clang_getTranslationUnitSpelling :: (CTUnit: CXTranslationUnit) -> CXString #foreign libclang;

clang_createTranslationUnitFromSourceFile :: (CIdx: CXIndex, source_filename: *u8, num_clang_command_line_args: s32, clang_command_line_args: **u8, num_unsaved_files: u32, unsaved_files: *CXUnsavedFile) -> CXTranslationUnit #foreign libclang;

clang_createTranslationUnit :: (CIdx: CXIndex, ast_filename: *u8) -> CXTranslationUnit #foreign libclang;

clang_createTranslationUnit2 :: (CIdx: CXIndex, ast_filename: *u8, out_TU: *CXTranslationUnit) -> CXErrorCode #foreign libclang;

using CXTranslationUnit_Flags :: enum u32 {
        CXTranslationUnit_None :: 0;
        CXTranslationUnit_DetailedPreprocessingRecord :: 1;
        CXTranslationUnit_Incomplete :: 2;
        CXTranslationUnit_PrecompiledPreamble :: 4;
        CXTranslationUnit_CacheCompletionResults :: 8;
        CXTranslationUnit_ForSerialization :: 16;
        CXTranslationUnit_CXXChainedPCH :: 32;
        CXTranslationUnit_SkipFunctionBodies :: 64;
        CXTranslationUnit_IncludeBriefCommentsInCodeCompletion :: 128;
        CXTranslationUnit_CreatePreambleOnFirstParse :: 256;
        CXTranslationUnit_KeepGoing :: 512;
        CXTranslationUnit_SingleFileParse :: 1024;
        CXTranslationUnit_LimitSkipFunctionBodiesToPreamble :: 2048;
        CXTranslationUnit_IncludeAttributedTypes :: 4096;
        CXTranslationUnit_VisitImplicitAttributes :: 8192;
}

clang_defaultEditingTranslationUnitOptions :: () -> u32 #foreign libclang;

clang_parseTranslationUnit :: (CIdx: CXIndex, source_filename: *u8, command_line_args: **u8, num_command_line_args: s32, unsaved_files: *CXUnsavedFile, num_unsaved_files: u32, options: u32) -> CXTranslationUnit #foreign libclang;

clang_parseTranslationUnit2 :: (CIdx: CXIndex, source_filename: *u8, command_line_args: **u8, num_command_line_args: s32, unsaved_files: *CXUnsavedFile, num_unsaved_files: u32, options: u32, out_TU: *CXTranslationUnit) -> CXErrorCode #foreign libclang;

clang_parseTranslationUnit2FullArgv :: (CIdx: CXIndex, source_filename: *u8, command_line_args: **u8, num_command_line_args: s32, unsaved_files: *CXUnsavedFile, num_unsaved_files: u32, options: u32, out_TU: *CXTranslationUnit) -> CXErrorCode #foreign libclang;

using CXSaveTranslationUnit_Flags :: enum u32 {
        CXSaveTranslationUnit_None :: 0;
}

clang_defaultSaveOptions :: (TU: CXTranslationUnit) -> u32 #foreign libclang;

using CXSaveError :: enum u32 {
        CXSaveError_None :: 0;
        CXSaveError_Unknown :: 1;
        CXSaveError_TranslationErrors :: 2;
        CXSaveError_InvalidTU :: 3;
}

clang_saveTranslationUnit :: (TU: CXTranslationUnit, FileName: *u8, options: u32) -> s32 #foreign libclang;

clang_suspendTranslationUnit :: (unk0: CXTranslationUnit) -> u32 #foreign libclang;

clang_disposeTranslationUnit :: (unk0: CXTranslationUnit) -> void #foreign libclang;

using CXReparse_Flags :: enum u32 {
        CXReparse_None :: 0;
}

clang_defaultReparseOptions :: (TU: CXTranslationUnit) -> u32 #foreign libclang;

clang_reparseTranslationUnit :: (TU: CXTranslationUnit, num_unsaved_files: u32, unsaved_files: *CXUnsavedFile, options: u32) -> s32 #foreign libclang;

using CXTUResourceUsageKind :: enum u32 {
        CXTUResourceUsage_AST :: 1;
        CXTUResourceUsage_Identifiers :: 2;
        CXTUResourceUsage_Selectors :: 3;
        CXTUResourceUsage_GlobalCompletionResults :: 4;
        CXTUResourceUsage_SourceManagerContentCache :: 5;
        CXTUResourceUsage_AST_SideTables :: 6;
        CXTUResourceUsage_SourceManager_Membuffer_Malloc :: 7;
        CXTUResourceUsage_SourceManager_Membuffer_MMap :: 8;
        CXTUResourceUsage_ExternalASTSource_Membuffer_Malloc :: 9;
        CXTUResourceUsage_ExternalASTSource_Membuffer_MMap :: 10;
        CXTUResourceUsage_Preprocessor :: 11;
        CXTUResourceUsage_PreprocessingRecord :: 12;
        CXTUResourceUsage_SourceManager_DataStructures :: 13;
        CXTUResourceUsage_Preprocessor_HeaderSearch :: 14;
        CXTUResourceUsage_MEMORY_IN_BYTES_BEGIN :: 1;
        CXTUResourceUsage_MEMORY_IN_BYTES_END :: 14;
        CXTUResourceUsage_First :: 1;
        CXTUResourceUsage_Last :: 14;
}

clang_getTUResourceUsageName :: (kind: CXTUResourceUsageKind) -> *u8 #foreign libclang;

CXTUResourceUsageEntry :: struct {
    kind: CXTUResourceUsageKind;
    amount: u64;
}



CXTUResourceUsage :: struct {
    data: *void;
    numEntries: u32;
    entries: *CXTUResourceUsageEntry;
}



clang_getCXTUResourceUsage :: (TU: CXTranslationUnit) -> CXTUResourceUsage #foreign libclang;

clang_disposeCXTUResourceUsage :: (usage: CXTUResourceUsage) -> void #foreign libclang;

clang_getTranslationUnitTargetInfo :: (CTUnit: CXTranslationUnit) -> CXTargetInfo #foreign libclang;

clang_TargetInfo_dispose :: (Info: CXTargetInfo) -> void #foreign libclang;

clang_TargetInfo_getTriple :: (Info: CXTargetInfo) -> CXString #foreign libclang;

clang_TargetInfo_getPointerWidth :: (Info: CXTargetInfo) -> s32 #foreign libclang;

using CXCursorKind :: enum u32 {
        CXCursor_UnexposedDecl :: 1;
        CXCursor_StructDecl :: 2;
        CXCursor_UnionDecl :: 3;
        CXCursor_ClassDecl :: 4;
        CXCursor_EnumDecl :: 5;
        CXCursor_FieldDecl :: 6;
        CXCursor_EnumConstantDecl :: 7;
        CXCursor_FunctionDecl :: 8;
        CXCursor_VarDecl :: 9;
        CXCursor_ParmDecl :: 10;
        CXCursor_ObjCInterfaceDecl :: 11;
        CXCursor_ObjCCategoryDecl :: 12;
        CXCursor_ObjCProtocolDecl :: 13;
        CXCursor_ObjCPropertyDecl :: 14;
        CXCursor_ObjCIvarDecl :: 15;
        CXCursor_ObjCInstanceMethodDecl :: 16;
        CXCursor_ObjCClassMethodDecl :: 17;
        CXCursor_ObjCImplementationDecl :: 18;
        CXCursor_ObjCCategoryImplDecl :: 19;
        CXCursor_TypedefDecl :: 20;
        CXCursor_CXXMethod :: 21;
        CXCursor_Namespace :: 22;
        CXCursor_LinkageSpec :: 23;
        CXCursor_Constructor :: 24;
        CXCursor_Destructor :: 25;
        CXCursor_ConversionFunction :: 26;
        CXCursor_TemplateTypeParameter :: 27;
        CXCursor_NonTypeTemplateParameter :: 28;
        CXCursor_TemplateTemplateParameter :: 29;
        CXCursor_FunctionTemplate :: 30;
        CXCursor_ClassTemplate :: 31;
        CXCursor_ClassTemplatePartialSpecialization :: 32;
        CXCursor_NamespaceAlias :: 33;
        CXCursor_UsingDirective :: 34;
        CXCursor_UsingDeclaration :: 35;
        CXCursor_TypeAliasDecl :: 36;
        CXCursor_ObjCSynthesizeDecl :: 37;
        CXCursor_ObjCDynamicDecl :: 38;
        CXCursor_CXXAccessSpecifier :: 39;
        CXCursor_FirstDecl :: 1;
        CXCursor_LastDecl :: 39;
        CXCursor_FirstRef :: 40;
        CXCursor_ObjCSuperClassRef :: 40;
        CXCursor_ObjCProtocolRef :: 41;
        CXCursor_ObjCClassRef :: 42;
        CXCursor_TypeRef :: 43;
        CXCursor_CXXBaseSpecifier :: 44;
        CXCursor_TemplateRef :: 45;
        CXCursor_NamespaceRef :: 46;
        CXCursor_MemberRef :: 47;
        CXCursor_LabelRef :: 48;
        CXCursor_OverloadedDeclRef :: 49;
        CXCursor_VariableRef :: 50;
        CXCursor_LastRef :: 50;
        CXCursor_FirstInvalid :: 70;
        CXCursor_InvalidFile :: 70;
        CXCursor_NoDeclFound :: 71;
        CXCursor_NotImplemented :: 72;
        CXCursor_InvalidCode :: 73;
        CXCursor_LastInvalid :: 73;
        CXCursor_FirstExpr :: 100;
        CXCursor_UnexposedExpr :: 100;
        CXCursor_DeclRefExpr :: 101;
        CXCursor_MemberRefExpr :: 102;
        CXCursor_CallExpr :: 103;
        CXCursor_ObjCMessageExpr :: 104;
        CXCursor_BlockExpr :: 105;
        CXCursor_IntegerLiteral :: 106;
        CXCursor_FloatingLiteral :: 107;
        CXCursor_ImaginaryLiteral :: 108;
        CXCursor_StringLiteral :: 109;
        CXCursor_CharacterLiteral :: 110;
        CXCursor_ParenExpr :: 111;
        CXCursor_UnaryOperator :: 112;
        CXCursor_ArraySubscriptExpr :: 113;
        CXCursor_BinaryOperator :: 114;
        CXCursor_CompoundAssignOperator :: 115;
        CXCursor_ConditionalOperator :: 116;
        CXCursor_CStyleCastExpr :: 117;
        CXCursor_CompoundLiteralExpr :: 118;
        CXCursor_InitListExpr :: 119;
        CXCursor_AddrLabelExpr :: 120;
        CXCursor_StmtExpr :: 121;
        CXCursor_GenericSelectionExpr :: 122;
        CXCursor_GNUNullExpr :: 123;
        CXCursor_CXXStaticCastExpr :: 124;
        CXCursor_CXXDynamicCastExpr :: 125;
        CXCursor_CXXReinterpretCastExpr :: 126;
        CXCursor_CXXConstCastExpr :: 127;
        CXCursor_CXXFunctionalCastExpr :: 128;
        CXCursor_CXXTypeidExpr :: 129;
        CXCursor_CXXBoolLiteralExpr :: 130;
        CXCursor_CXXNullPtrLiteralExpr :: 131;
        CXCursor_CXXThisExpr :: 132;
        CXCursor_CXXThrowExpr :: 133;
        CXCursor_CXXNewExpr :: 134;
        CXCursor_CXXDeleteExpr :: 135;
        CXCursor_UnaryExpr :: 136;
        CXCursor_ObjCStringLiteral :: 137;
        CXCursor_ObjCEncodeExpr :: 138;
        CXCursor_ObjCSelectorExpr :: 139;
        CXCursor_ObjCProtocolExpr :: 140;
        CXCursor_ObjCBridgedCastExpr :: 141;
        CXCursor_PackExpansionExpr :: 142;
        CXCursor_SizeOfPackExpr :: 143;
        CXCursor_LambdaExpr :: 144;
        CXCursor_ObjCBoolLiteralExpr :: 145;
        CXCursor_ObjCSelfExpr :: 146;
        CXCursor_OMPArraySectionExpr :: 147;
        CXCursor_ObjCAvailabilityCheckExpr :: 148;
        CXCursor_FixedPointLiteral :: 149;
        CXCursor_LastExpr :: 149;
        CXCursor_FirstStmt :: 200;
        CXCursor_UnexposedStmt :: 200;
        CXCursor_LabelStmt :: 201;
        CXCursor_CompoundStmt :: 202;
        CXCursor_CaseStmt :: 203;
        CXCursor_DefaultStmt :: 204;
        CXCursor_IfStmt :: 205;
        CXCursor_SwitchStmt :: 206;
        CXCursor_WhileStmt :: 207;
        CXCursor_DoStmt :: 208;
        CXCursor_ForStmt :: 209;
        CXCursor_GotoStmt :: 210;
        CXCursor_IndirectGotoStmt :: 211;
        CXCursor_ContinueStmt :: 212;
        CXCursor_BreakStmt :: 213;
        CXCursor_ReturnStmt :: 214;
        CXCursor_GCCAsmStmt :: 215;
        CXCursor_AsmStmt :: 215;
        CXCursor_ObjCAtTryStmt :: 216;
        CXCursor_ObjCAtCatchStmt :: 217;
        CXCursor_ObjCAtFinallyStmt :: 218;
        CXCursor_ObjCAtThrowStmt :: 219;
        CXCursor_ObjCAtSynchronizedStmt :: 220;
        CXCursor_ObjCAutoreleasePoolStmt :: 221;
        CXCursor_ObjCForCollectionStmt :: 222;
        CXCursor_CXXCatchStmt :: 223;
        CXCursor_CXXTryStmt :: 224;
        CXCursor_CXXForRangeStmt :: 225;
        CXCursor_SEHTryStmt :: 226;
        CXCursor_SEHExceptStmt :: 227;
        CXCursor_SEHFinallyStmt :: 228;
        CXCursor_MSAsmStmt :: 229;
        CXCursor_NullStmt :: 230;
        CXCursor_DeclStmt :: 231;
        CXCursor_OMPParallelDirective :: 232;
        CXCursor_OMPSimdDirective :: 233;
        CXCursor_OMPForDirective :: 234;
        CXCursor_OMPSectionsDirective :: 235;
        CXCursor_OMPSectionDirective :: 236;
        CXCursor_OMPSingleDirective :: 237;
        CXCursor_OMPParallelForDirective :: 238;
        CXCursor_OMPParallelSectionsDirective :: 239;
        CXCursor_OMPTaskDirective :: 240;
        CXCursor_OMPMasterDirective :: 241;
        CXCursor_OMPCriticalDirective :: 242;
        CXCursor_OMPTaskyieldDirective :: 243;
        CXCursor_OMPBarrierDirective :: 244;
        CXCursor_OMPTaskwaitDirective :: 245;
        CXCursor_OMPFlushDirective :: 246;
        CXCursor_SEHLeaveStmt :: 247;
        CXCursor_OMPOrderedDirective :: 248;
        CXCursor_OMPAtomicDirective :: 249;
        CXCursor_OMPForSimdDirective :: 250;
        CXCursor_OMPParallelForSimdDirective :: 251;
        CXCursor_OMPTargetDirective :: 252;
        CXCursor_OMPTeamsDirective :: 253;
        CXCursor_OMPTaskgroupDirective :: 254;
        CXCursor_OMPCancellationPointDirective :: 255;
        CXCursor_OMPCancelDirective :: 256;
        CXCursor_OMPTargetDataDirective :: 257;
        CXCursor_OMPTaskLoopDirective :: 258;
        CXCursor_OMPTaskLoopSimdDirective :: 259;
        CXCursor_OMPDistributeDirective :: 260;
        CXCursor_OMPTargetEnterDataDirective :: 261;
        CXCursor_OMPTargetExitDataDirective :: 262;
        CXCursor_OMPTargetParallelDirective :: 263;
        CXCursor_OMPTargetParallelForDirective :: 264;
        CXCursor_OMPTargetUpdateDirective :: 265;
        CXCursor_OMPDistributeParallelForDirective :: 266;
        CXCursor_OMPDistributeParallelForSimdDirective :: 267;
        CXCursor_OMPDistributeSimdDirective :: 268;
        CXCursor_OMPTargetParallelForSimdDirective :: 269;
        CXCursor_OMPTargetSimdDirective :: 270;
        CXCursor_OMPTeamsDistributeDirective :: 271;
        CXCursor_OMPTeamsDistributeSimdDirective :: 272;
        CXCursor_OMPTeamsDistributeParallelForSimdDirective :: 273;
        CXCursor_OMPTeamsDistributeParallelForDirective :: 274;
        CXCursor_OMPTargetTeamsDirective :: 275;
        CXCursor_OMPTargetTeamsDistributeDirective :: 276;
        CXCursor_OMPTargetTeamsDistributeParallelForDirective :: 277;
        CXCursor_OMPTargetTeamsDistributeParallelForSimdDirective :: 278;
        CXCursor_OMPTargetTeamsDistributeSimdDirective :: 279;
        CXCursor_LastStmt :: 279;
        CXCursor_TranslationUnit :: 300;
        CXCursor_FirstAttr :: 400;
        CXCursor_UnexposedAttr :: 400;
        CXCursor_IBActionAttr :: 401;
        CXCursor_IBOutletAttr :: 402;
        CXCursor_IBOutletCollectionAttr :: 403;
        CXCursor_CXXFinalAttr :: 404;
        CXCursor_CXXOverrideAttr :: 405;
        CXCursor_AnnotateAttr :: 406;
        CXCursor_AsmLabelAttr :: 407;
        CXCursor_PackedAttr :: 408;
        CXCursor_PureAttr :: 409;
        CXCursor_ConstAttr :: 410;
        CXCursor_NoDuplicateAttr :: 411;
        CXCursor_CUDAConstantAttr :: 412;
        CXCursor_CUDADeviceAttr :: 413;
        CXCursor_CUDAGlobalAttr :: 414;
        CXCursor_CUDAHostAttr :: 415;
        CXCursor_CUDASharedAttr :: 416;
        CXCursor_VisibilityAttr :: 417;
        CXCursor_DLLExport :: 418;
        CXCursor_DLLImport :: 419;
        CXCursor_NSReturnsRetained :: 420;
        CXCursor_NSReturnsNotRetained :: 421;
        CXCursor_NSReturnsAutoreleased :: 422;
        CXCursor_NSConsumesSelf :: 423;
        CXCursor_NSConsumed :: 424;
        CXCursor_ObjCException :: 425;
        CXCursor_ObjCNSObject :: 426;
        CXCursor_ObjCIndependentClass :: 427;
        CXCursor_ObjCPreciseLifetime :: 428;
        CXCursor_ObjCReturnsInnerPointer :: 429;
        CXCursor_ObjCRequiresSuper :: 430;
        CXCursor_ObjCRootClass :: 431;
        CXCursor_ObjCSubclassingRestricted :: 432;
        CXCursor_ObjCExplicitProtocolImpl :: 433;
        CXCursor_ObjCDesignatedInitializer :: 434;
        CXCursor_ObjCRuntimeVisible :: 435;
        CXCursor_ObjCBoxable :: 436;
        CXCursor_FlagEnum :: 437;
        CXCursor_LastAttr :: 437;
        CXCursor_PreprocessingDirective :: 500;
        CXCursor_MacroDefinition :: 501;
        CXCursor_MacroExpansion :: 502;
        CXCursor_MacroInstantiation :: 502;
        CXCursor_InclusionDirective :: 503;
        CXCursor_FirstPreprocessing :: 500;
        CXCursor_LastPreprocessing :: 503;
        CXCursor_ModuleImportDecl :: 600;
        CXCursor_TypeAliasTemplateDecl :: 601;
        CXCursor_StaticAssert :: 602;
        CXCursor_FriendDecl :: 603;
        CXCursor_FirstExtraDecl :: 600;
        CXCursor_LastExtraDecl :: 603;
        CXCursor_OverloadCandidate :: 700;
}

CXCursor :: struct {
    kind: CXCursorKind;
    xdata: s32;
    data: [3] *void;
}

clang_getNullCursor :: () -> CXCursor #foreign libclang;

clang_getTranslationUnitCursor :: (unk0: CXTranslationUnit) -> CXCursor #foreign libclang;

clang_equalCursors :: (unk0: CXCursor, unk1: CXCursor) -> u32 #foreign libclang;

clang_Cursor_isNull :: (cursor: CXCursor) -> s32 #foreign libclang;

clang_hashCursor :: (unk0: CXCursor) -> u32 #foreign libclang;

clang_getCursorKind :: (unk0: CXCursor) -> CXCursorKind #foreign libclang;

clang_isDeclaration :: (unk0: CXCursorKind) -> u32 #foreign libclang;

clang_isInvalidDeclaration :: (unk0: CXCursor) -> u32 #foreign libclang;

clang_isReference :: (unk0: CXCursorKind) -> u32 #foreign libclang;

clang_isExpression :: (unk0: CXCursorKind) -> u32 #foreign libclang;

clang_isStatement :: (unk0: CXCursorKind) -> u32 #foreign libclang;

clang_isAttribute :: (unk0: CXCursorKind) -> u32 #foreign libclang;

clang_Cursor_hasAttrs :: (C: CXCursor) -> u32 #foreign libclang;

clang_isInvalid :: (unk0: CXCursorKind) -> u32 #foreign libclang;

clang_isTranslationUnit :: (unk0: CXCursorKind) -> u32 #foreign libclang;

clang_isPreprocessing :: (unk0: CXCursorKind) -> u32 #foreign libclang;

clang_isUnexposed :: (unk0: CXCursorKind) -> u32 #foreign libclang;

using CXLinkageKind :: enum u32 {
        CXLinkage_Invalid :: 0;
        CXLinkage_NoLinkage :: 1;
        CXLinkage_Internal :: 2;
        CXLinkage_UniqueExternal :: 3;
        CXLinkage_External :: 4;
}

clang_getCursorLinkage :: (cursor: CXCursor) -> CXLinkageKind #foreign libclang;

using CXVisibilityKind :: enum u32 {
        CXVisibility_Invalid :: 0;
        CXVisibility_Hidden :: 1;
        CXVisibility_Protected :: 2;
        CXVisibility_Default :: 3;
}

clang_getCursorVisibility :: (cursor: CXCursor) -> CXVisibilityKind #foreign libclang;

clang_getCursorAvailability :: (cursor: CXCursor) -> CXAvailabilityKind #foreign libclang;

CXPlatformAvailability :: struct {
    Platform: CXString;
    Introduced: CXVersion;
    Deprecated: CXVersion;
    Obsoleted: CXVersion;
    Unavailable: s32;
    Message: CXString;
}



clang_getCursorPlatformAvailability :: (cursor: CXCursor, always_deprecated: *s32, deprecated_message: *CXString, always_unavailable: *s32, unavailable_message: *CXString, availability: *CXPlatformAvailability, availability_size: s32) -> s32 #foreign libclang;

clang_disposeCXPlatformAvailability :: (availability: *CXPlatformAvailability) -> void #foreign libclang;

using CXLanguageKind :: enum u32 {
        CXLanguage_Invalid :: 0;
        CXLanguage_C :: 1;
        CXLanguage_ObjC :: 2;
        CXLanguage_CPlusPlus :: 3;
}

clang_getCursorLanguage :: (cursor: CXCursor) -> CXLanguageKind #foreign libclang;

using CXTLSKind :: enum u32 {
        CXTLS_None :: 0;
        CXTLS_Dynamic :: 1;
        CXTLS_Static :: 2;
}

clang_getCursorTLSKind :: (cursor: CXCursor) -> CXTLSKind #foreign libclang;

clang_Cursor_getTranslationUnit :: (unk0: CXCursor) -> CXTranslationUnit #foreign libclang;

CXCursorSetImpl :: struct {
}

CXCursorSet :: *CXCursorSetImpl;

clang_createCXCursorSet :: () -> CXCursorSet #foreign libclang;

clang_disposeCXCursorSet :: (cset: CXCursorSet) -> void #foreign libclang;

clang_CXCursorSet_contains :: (cset: CXCursorSet, cursor: CXCursor) -> u32 #foreign libclang;

clang_CXCursorSet_insert :: (cset: CXCursorSet, cursor: CXCursor) -> u32 #foreign libclang;

clang_getCursorSemanticParent :: (cursor: CXCursor) -> CXCursor #foreign libclang;

clang_getCursorLexicalParent :: (cursor: CXCursor) -> CXCursor #foreign libclang;

clang_getOverriddenCursors :: (cursor: CXCursor, overridden: **CXCursor, num_overridden: *u32) -> void #foreign libclang;

clang_disposeOverriddenCursors :: (overridden: *CXCursor) -> void #foreign libclang;

clang_getIncludedFile :: (cursor: CXCursor) -> CXFile #foreign libclang;

clang_getCursor :: (unk0: CXTranslationUnit, unk1: CXSourceLocation) -> CXCursor #foreign libclang;

clang_getCursorLocation :: (unk0: CXCursor) -> CXSourceLocation #foreign libclang;

clang_getCursorExtent :: (unk0: CXCursor) -> CXSourceRange #foreign libclang;

using CXTypeKind :: enum u32 {
        CXType_Invalid :: 0;
        CXType_Unexposed :: 1;
        CXType_Void :: 2;
        CXType_Bool :: 3;
        CXType_Char_U :: 4;
        CXType_UChar :: 5;
        CXType_Char16 :: 6;
        CXType_Char32 :: 7;
        CXType_UShort :: 8;
        CXType_UInt :: 9;
        CXType_ULong :: 10;
        CXType_ULongLong :: 11;
        CXType_UInt128 :: 12;
        CXType_Char_S :: 13;
        CXType_SChar :: 14;
        CXType_WChar :: 15;
        CXType_Short :: 16;
        CXType_Int :: 17;
        CXType_Long :: 18;
        CXType_LongLong :: 19;
        CXType_Int128 :: 20;
        CXType_Float :: 21;
        CXType_Double :: 22;
        CXType_LongDouble :: 23;
        CXType_NullPtr :: 24;
        CXType_Overload :: 25;
        CXType_Dependent :: 26;
        CXType_ObjCId :: 27;
        CXType_ObjCClass :: 28;
        CXType_ObjCSel :: 29;
        CXType_Float128 :: 30;
        CXType_Half :: 31;
        CXType_Float16 :: 32;
        CXType_ShortAccum :: 33;
        CXType_Accum :: 34;
        CXType_LongAccum :: 35;
        CXType_UShortAccum :: 36;
        CXType_UAccum :: 37;
        CXType_ULongAccum :: 38;
        CXType_FirstBuiltin :: 2;
        CXType_LastBuiltin :: 38;
        CXType_Complex :: 100;
        CXType_Pointer :: 101;
        CXType_BlockPointer :: 102;
        CXType_LValueReference :: 103;
        CXType_RValueReference :: 104;
        CXType_Record :: 105;
        CXType_Enum :: 106;
        CXType_Typedef :: 107;
        CXType_ObjCInterface :: 108;
        CXType_ObjCObjectPointer :: 109;
        CXType_FunctionNoProto :: 110;
        CXType_FunctionProto :: 111;
        CXType_ConstantArray :: 112;
        CXType_Vector :: 113;
        CXType_IncompleteArray :: 114;
        CXType_VariableArray :: 115;
        CXType_DependentSizedArray :: 116;
        CXType_MemberPointer :: 117;
        CXType_Auto :: 118;
        CXType_Elaborated :: 119;
        CXType_Pipe :: 120;
        CXType_OCLImage1dRO :: 121;
        CXType_OCLImage1dArrayRO :: 122;
        CXType_OCLImage1dBufferRO :: 123;
        CXType_OCLImage2dRO :: 124;
        CXType_OCLImage2dArrayRO :: 125;
        CXType_OCLImage2dDepthRO :: 126;
        CXType_OCLImage2dArrayDepthRO :: 127;
        CXType_OCLImage2dMSAARO :: 128;
        CXType_OCLImage2dArrayMSAARO :: 129;
        CXType_OCLImage2dMSAADepthRO :: 130;
        CXType_OCLImage2dArrayMSAADepthRO :: 131;
        CXType_OCLImage3dRO :: 132;
        CXType_OCLImage1dWO :: 133;
        CXType_OCLImage1dArrayWO :: 134;
        CXType_OCLImage1dBufferWO :: 135;
        CXType_OCLImage2dWO :: 136;
        CXType_OCLImage2dArrayWO :: 137;
        CXType_OCLImage2dDepthWO :: 138;
        CXType_OCLImage2dArrayDepthWO :: 139;
        CXType_OCLImage2dMSAAWO :: 140;
        CXType_OCLImage2dArrayMSAAWO :: 141;
        CXType_OCLImage2dMSAADepthWO :: 142;
        CXType_OCLImage2dArrayMSAADepthWO :: 143;
        CXType_OCLImage3dWO :: 144;
        CXType_OCLImage1dRW :: 145;
        CXType_OCLImage1dArrayRW :: 146;
        CXType_OCLImage1dBufferRW :: 147;
        CXType_OCLImage2dRW :: 148;
        CXType_OCLImage2dArrayRW :: 149;
        CXType_OCLImage2dDepthRW :: 150;
        CXType_OCLImage2dArrayDepthRW :: 151;
        CXType_OCLImage2dMSAARW :: 152;
        CXType_OCLImage2dArrayMSAARW :: 153;
        CXType_OCLImage2dMSAADepthRW :: 154;
        CXType_OCLImage2dArrayMSAADepthRW :: 155;
        CXType_OCLImage3dRW :: 156;
        CXType_OCLSampler :: 157;
        CXType_OCLEvent :: 158;
        CXType_OCLQueue :: 159;
        CXType_OCLReserveID :: 160;
        CXType_ObjCObject :: 161;
        CXType_ObjCTypeParam :: 162;
        CXType_Attributed :: 163;
        CXType_OCLIntelSubgroupAVCMcePayload :: 164;
        CXType_OCLIntelSubgroupAVCImePayload :: 165;
        CXType_OCLIntelSubgroupAVCRefPayload :: 166;
        CXType_OCLIntelSubgroupAVCSicPayload :: 167;
        CXType_OCLIntelSubgroupAVCMceResult :: 168;
        CXType_OCLIntelSubgroupAVCImeResult :: 169;
        CXType_OCLIntelSubgroupAVCRefResult :: 170;
        CXType_OCLIntelSubgroupAVCSicResult :: 171;
        CXType_OCLIntelSubgroupAVCImeResultSingleRefStreamout :: 172;
        CXType_OCLIntelSubgroupAVCImeResultDualRefStreamout :: 173;
        CXType_OCLIntelSubgroupAVCImeSingleRefStreamin :: 174;
        CXType_OCLIntelSubgroupAVCImeDualRefStreamin :: 175;
}

using CXCallingConv :: enum u32 {
        CXCallingConv_Default :: 0;
        CXCallingConv_C :: 1;
        CXCallingConv_X86StdCall :: 2;
        CXCallingConv_X86FastCall :: 3;
        CXCallingConv_X86ThisCall :: 4;
        CXCallingConv_X86Pascal :: 5;
        CXCallingConv_AAPCS :: 6;
        CXCallingConv_AAPCS_VFP :: 7;
        CXCallingConv_X86RegCall :: 8;
        CXCallingConv_IntelOclBicc :: 9;
        CXCallingConv_Win64 :: 10;
        CXCallingConv_X86_64Win64 :: 10;
        CXCallingConv_X86_64SysV :: 11;
        CXCallingConv_X86VectorCall :: 12;
        CXCallingConv_Swift :: 13;
        CXCallingConv_PreserveMost :: 14;
        CXCallingConv_PreserveAll :: 15;
        CXCallingConv_AArch64VectorCall :: 16;
        CXCallingConv_Invalid :: 100;
        CXCallingConv_Unexposed :: 200;
}

CXType :: struct {
    kind: CXTypeKind;
    data: [2] *void;
}

clang_getCursorType :: (C: CXCursor) -> CXType #foreign libclang;

clang_getTypeSpelling :: (CT: CXType) -> CXString #foreign libclang;

clang_getTypedefDeclUnderlyingType :: (C: CXCursor) -> CXType #foreign libclang;

clang_getEnumDeclIntegerType :: (C: CXCursor) -> CXType #foreign libclang;

clang_getEnumConstantDeclValue :: (C: CXCursor) -> s64 #foreign libclang;

clang_getEnumConstantDeclUnsignedValue :: (C: CXCursor) -> u64 #foreign libclang;

clang_getFieldDeclBitWidth :: (C: CXCursor) -> s32 #foreign libclang;

clang_Cursor_getNumArguments :: (C: CXCursor) -> s32 #foreign libclang;

clang_Cursor_getArgument :: (C: CXCursor, i: u32) -> CXCursor #foreign libclang;

using CXTemplateArgumentKind :: enum u32 {
        CXTemplateArgumentKind_Null :: 0;
        CXTemplateArgumentKind_Type :: 1;
        CXTemplateArgumentKind_Declaration :: 2;
        CXTemplateArgumentKind_NullPtr :: 3;
        CXTemplateArgumentKind_Integral :: 4;
        CXTemplateArgumentKind_Template :: 5;
        CXTemplateArgumentKind_TemplateExpansion :: 6;
        CXTemplateArgumentKind_Expression :: 7;
        CXTemplateArgumentKind_Pack :: 8;
        CXTemplateArgumentKind_Invalid :: 9;
}

clang_Cursor_getNumTemplateArguments :: (C: CXCursor) -> s32 #foreign libclang;

clang_Cursor_getTemplateArgumentKind :: (C: CXCursor, I: u32) -> CXTemplateArgumentKind #foreign libclang;

clang_Cursor_getTemplateArgumentType :: (C: CXCursor, I: u32) -> CXType #foreign libclang;

clang_Cursor_getTemplateArgumentValue :: (C: CXCursor, I: u32) -> s64 #foreign libclang;

clang_Cursor_getTemplateArgumentUnsignedValue :: (C: CXCursor, I: u32) -> u64 #foreign libclang;

clang_equalTypes :: (A: CXType, B: CXType) -> u32 #foreign libclang;

clang_getCanonicalType :: (T: CXType) -> CXType #foreign libclang;

clang_isConstQualifiedType :: (T: CXType) -> u32 #foreign libclang;

clang_Cursor_isMacroFunctionLike :: (C: CXCursor) -> u32 #foreign libclang;

clang_Cursor_isMacroBuiltin :: (C: CXCursor) -> u32 #foreign libclang;

clang_Cursor_isFunctionInlined :: (C: CXCursor) -> u32 #foreign libclang;

clang_isVolatileQualifiedType :: (T: CXType) -> u32 #foreign libclang;

clang_isRestrictQualifiedType :: (T: CXType) -> u32 #foreign libclang;

clang_getAddressSpace :: (T: CXType) -> u32 #foreign libclang;

clang_getTypedefName :: (CT: CXType) -> CXString #foreign libclang;

clang_getPointeeType :: (T: CXType) -> CXType #foreign libclang;

clang_getTypeDeclaration :: (T: CXType) -> CXCursor #foreign libclang;

clang_getDeclObjCTypeEncoding :: (C: CXCursor) -> CXString #foreign libclang;

clang_Type_getObjCEncoding :: (type: CXType) -> CXString #foreign libclang;

clang_getTypeKindSpelling :: (K: CXTypeKind) -> CXString #foreign libclang;

clang_getFunctionTypeCallingConv :: (T: CXType) -> CXCallingConv #foreign libclang;

clang_getResultType :: (T: CXType) -> CXType #foreign libclang;

clang_getExceptionSpecificationType :: (T: CXType) -> s32 #foreign libclang;

clang_getNumArgTypes :: (T: CXType) -> s32 #foreign libclang;

clang_getArgType :: (T: CXType, i: u32) -> CXType #foreign libclang;

clang_Type_getObjCObjectBaseType :: (T: CXType) -> CXType #foreign libclang;

clang_Type_getNumObjCProtocolRefs :: (T: CXType) -> u32 #foreign libclang;

clang_Type_getObjCProtocolDecl :: (T: CXType, i: u32) -> CXCursor #foreign libclang;

clang_Type_getNumObjCTypeArgs :: (T: CXType) -> u32 #foreign libclang;

clang_Type_getObjCTypeArg :: (T: CXType, i: u32) -> CXType #foreign libclang;

clang_isFunctionTypeVariadic :: (T: CXType) -> u32 #foreign libclang;

clang_getCursorResultType :: (C: CXCursor) -> CXType #foreign libclang;

clang_getCursorExceptionSpecificationType :: (C: CXCursor) -> s32 #foreign libclang;

clang_isPODType :: (T: CXType) -> u32 #foreign libclang;

clang_getElementType :: (T: CXType) -> CXType #foreign libclang;

clang_getNumElements :: (T: CXType) -> s64 #foreign libclang;

clang_getArrayElementType :: (T: CXType) -> CXType #foreign libclang;

clang_getArraySize :: (T: CXType) -> s64 #foreign libclang;

clang_Type_getNamedType :: (T: CXType) -> CXType #foreign libclang;

clang_Type_isTransparentTagTypedef :: (T: CXType) -> u32 #foreign libclang;

using CXTypeNullabilityKind :: enum u32 {
        CXTypeNullability_NonNull :: 0;
        CXTypeNullability_Nullable :: 1;
        CXTypeNullability_Unspecified :: 2;
        CXTypeNullability_Invalid :: 3;
}

clang_Type_getNullability :: (T: CXType) -> CXTypeNullabilityKind #foreign libclang;

using CXTypeLayoutError :: enum s32 {
        CXTypeLayoutError_Invalid :: -1;
        CXTypeLayoutError_Incomplete :: -2;
        CXTypeLayoutError_Dependent :: -3;
        CXTypeLayoutError_NotConstantSize :: -4;
        CXTypeLayoutError_InvalidFieldName :: -5;
}

clang_Type_getAlignOf :: (T: CXType) -> s64 #foreign libclang;

clang_Type_getClassType :: (T: CXType) -> CXType #foreign libclang;

clang_Type_getSizeOf :: (T: CXType) -> s64 #foreign libclang;

clang_Type_getOffsetOf :: (T: CXType, S: *u8) -> s64 #foreign libclang;

clang_Type_getModifiedType :: (T: CXType) -> CXType #foreign libclang;

clang_Cursor_getOffsetOfField :: (C: CXCursor) -> s64 #foreign libclang;

clang_Cursor_isAnonymous :: (C: CXCursor) -> u32 #foreign libclang;

using CXRefQualifierKind :: enum u32 {
        CXRefQualifier_None :: 0;
        CXRefQualifier_LValue :: 1;
        CXRefQualifier_RValue :: 2;
}

clang_Type_getNumTemplateArguments :: (T: CXType) -> s32 #foreign libclang;

clang_Type_getTemplateArgumentAsType :: (T: CXType, i: u32) -> CXType #foreign libclang;

clang_Type_getCXXRefQualifier :: (T: CXType) -> CXRefQualifierKind #foreign libclang;

clang_Cursor_isBitField :: (C: CXCursor) -> u32 #foreign libclang;

clang_isVirtualBase :: (unk0: CXCursor) -> u32 #foreign libclang;

using CX_CXXAccessSpecifier :: enum u32 {
        CX_CXXInvalidAccessSpecifier :: 0;
        CX_CXXPublic :: 1;
        CX_CXXProtected :: 2;
        CX_CXXPrivate :: 3;
}

clang_getCXXAccessSpecifier :: (unk0: CXCursor) -> CX_CXXAccessSpecifier #foreign libclang;

using CX_StorageClass :: enum u32 {
        CX_SC_Invalid :: 0;
        CX_SC_None :: 1;
        CX_SC_Extern :: 2;
        CX_SC_Static :: 3;
        CX_SC_PrivateExtern :: 4;
        CX_SC_OpenCLWorkGroupLocal :: 5;
        CX_SC_Auto :: 6;
        CX_SC_Register :: 7;
}

clang_Cursor_getStorageClass :: (unk0: CXCursor) -> CX_StorageClass #foreign libclang;

clang_getNumOverloadedDecls :: (cursor: CXCursor) -> u32 #foreign libclang;

clang_getOverloadedDecl :: (cursor: CXCursor, index: u32) -> CXCursor #foreign libclang;

clang_getIBOutletCollectionType :: (unk0: CXCursor) -> CXType #foreign libclang;

using CXChildVisitResult :: enum u32 {
        CXChildVisit_Break :: 0;
        CXChildVisit_Continue :: 1;
        CXChildVisit_Recurse :: 2;
}

CXCursorVisitor :: #type (a0: CXCursor, a1: CXCursor, a2: CXClientData) -> CXChildVisitResult #c_call;

clang_visitChildren :: (parent: CXCursor, visitor: CXCursorVisitor, client_data: CXClientData) -> u32 #foreign libclang;

clang_getCursorUSR :: (unk0: CXCursor) -> CXString #foreign libclang;

clang_constructUSR_ObjCClass :: (class_name: *u8) -> CXString #foreign libclang;

clang_constructUSR_ObjCCategory :: (class_name: *u8, category_name: *u8) -> CXString #foreign libclang;

clang_constructUSR_ObjCProtocol :: (protocol_name: *u8) -> CXString #foreign libclang;

clang_constructUSR_ObjCIvar :: (name: *u8, classUSR: CXString) -> CXString #foreign libclang;

clang_constructUSR_ObjCMethod :: (name: *u8, isInstanceMethod: u32, classUSR: CXString) -> CXString #foreign libclang;

clang_constructUSR_ObjCProperty :: (property: *u8, classUSR: CXString) -> CXString #foreign libclang;

clang_getCursorSpelling :: (unk0: CXCursor) -> CXString #foreign libclang;

clang_Cursor_getSpellingNameRange :: (unk0: CXCursor, pieceIndex: u32, options: u32) -> CXSourceRange #foreign libclang;

CXPrintingPolicy :: *void;

using CXPrintingPolicyProperty :: enum u32 {
        CXPrintingPolicy_Indentation :: 0;
        CXPrintingPolicy_SuppressSpecifiers :: 1;
        CXPrintingPolicy_SuppressTagKeyword :: 2;
        CXPrintingPolicy_IncludeTagDefinition :: 3;
        CXPrintingPolicy_SuppressScope :: 4;
        CXPrintingPolicy_SuppressUnwrittenScope :: 5;
        CXPrintingPolicy_SuppressInitializers :: 6;
        CXPrintingPolicy_ConstantArraySizeAsWritten :: 7;
        CXPrintingPolicy_AnonymousTagLocations :: 8;
        CXPrintingPolicy_SuppressStrongLifetime :: 9;
        CXPrintingPolicy_SuppressLifetimeQualifiers :: 10;
        CXPrintingPolicy_SuppressTemplateArgsInCXXConstructors :: 11;
        CXPrintingPolicy_Bool :: 12;
        CXPrintingPolicy_Restrict :: 13;
        CXPrintingPolicy_Alignof :: 14;
        CXPrintingPolicy_UnderscoreAlignof :: 15;
        CXPrintingPolicy_UseVoidForZeroParams :: 16;
        CXPrintingPolicy_TerseOutput :: 17;
        CXPrintingPolicy_PolishForDeclaration :: 18;
        CXPrintingPolicy_Half :: 19;
        CXPrintingPolicy_MSWChar :: 20;
        CXPrintingPolicy_IncludeNewlines :: 21;
        CXPrintingPolicy_MSVCFormatting :: 22;
        CXPrintingPolicy_ConstantsAsWritten :: 23;
        CXPrintingPolicy_SuppressImplicitBase :: 24;
        CXPrintingPolicy_FullyQualifiedName :: 25;
        CXPrintingPolicy_LastProperty :: 25;
}

clang_PrintingPolicy_getProperty :: (Policy: CXPrintingPolicy, Property: CXPrintingPolicyProperty) -> u32 #foreign libclang;

clang_PrintingPolicy_setProperty :: (Policy: CXPrintingPolicy, Property: CXPrintingPolicyProperty, Value: u32) -> void #foreign libclang;

clang_getCursorPrintingPolicy :: (unk0: CXCursor) -> CXPrintingPolicy #foreign libclang;

clang_PrintingPolicy_dispose :: (Policy: CXPrintingPolicy) -> void #foreign libclang;

clang_getCursorPrettyPrinted :: (Cursor: CXCursor, Policy: CXPrintingPolicy) -> CXString #foreign libclang;

clang_getCursorDisplayName :: (unk0: CXCursor) -> CXString #foreign libclang;

clang_getCursorReferenced :: (unk0: CXCursor) -> CXCursor #foreign libclang;

clang_getCursorDefinition :: (unk0: CXCursor) -> CXCursor #foreign libclang;

clang_isCursorDefinition :: (unk0: CXCursor) -> u32 #foreign libclang;

clang_getCanonicalCursor :: (unk0: CXCursor) -> CXCursor #foreign libclang;

clang_Cursor_getObjCSelectorIndex :: (unk0: CXCursor) -> s32 #foreign libclang;

clang_Cursor_isDynamicCall :: (C: CXCursor) -> s32 #foreign libclang;

clang_Cursor_getReceiverType :: (C: CXCursor) -> CXType #foreign libclang;

using anon_enum_9 :: enum u32 {
    CXObjCPropertyAttr_noattr :: 0;
    CXObjCPropertyAttr_readonly :: 1;
    CXObjCPropertyAttr_getter :: 2;
    CXObjCPropertyAttr_assign :: 4;
    CXObjCPropertyAttr_readwrite :: 8;
    CXObjCPropertyAttr_retain :: 16;
    CXObjCPropertyAttr_copy :: 32;
    CXObjCPropertyAttr_nonatomic :: 64;
    CXObjCPropertyAttr_setter :: 128;
    CXObjCPropertyAttr_atomic :: 256;
    CXObjCPropertyAttr_weak :: 512;
    CXObjCPropertyAttr_strong :: 1024;
    CXObjCPropertyAttr_unsafe_unretained :: 2048;
    CXObjCPropertyAttr_class :: 4096;
}

CXObjCPropertyAttrKind :: anon_enum_9;

clang_Cursor_getObjCPropertyAttributes :: (C: CXCursor, reserved: u32) -> u32 #foreign libclang;

clang_Cursor_getObjCPropertyGetterName :: (C: CXCursor) -> CXString #foreign libclang;

clang_Cursor_getObjCPropertySetterName :: (C: CXCursor) -> CXString #foreign libclang;

using anon_enum_10 :: enum u32 {
        CXObjCDeclQualifier_None :: 0;
        CXObjCDeclQualifier_In :: 1;
        CXObjCDeclQualifier_Inout :: 2;
        CXObjCDeclQualifier_Out :: 4;
        CXObjCDeclQualifier_Bycopy :: 8;
        CXObjCDeclQualifier_Byref :: 16;
        CXObjCDeclQualifier_Oneway :: 32;
}

CXObjCDeclQualifierKind :: anon_enum_10;

clang_Cursor_getObjCDeclQualifiers :: (C: CXCursor) -> u32 #foreign libclang;

clang_Cursor_isObjCOptional :: (C: CXCursor) -> u32 #foreign libclang;

clang_Cursor_isVariadic :: (C: CXCursor) -> u32 #foreign libclang;

clang_Cursor_isExternalSymbol :: (C: CXCursor, language: *CXString, definedIn: *CXString, isGenerated: *u32) -> u32 #foreign libclang;

clang_Cursor_getCommentRange :: (C: CXCursor) -> CXSourceRange #foreign libclang;

clang_Cursor_getRawCommentText :: (C: CXCursor) -> CXString #foreign libclang;

clang_Cursor_getBriefCommentText :: (C: CXCursor) -> CXString #foreign libclang;

clang_Cursor_getMangling :: (unk0: CXCursor) -> CXString #foreign libclang;

clang_Cursor_getCXXManglings :: (unk0: CXCursor) -> *CXStringSet #foreign libclang;

clang_Cursor_getObjCManglings :: (unk0: CXCursor) -> *CXStringSet #foreign libclang;

CXModule :: *void;

clang_Cursor_getModule :: (C: CXCursor) -> CXModule #foreign libclang;

clang_getModuleForFile :: (unk0: CXTranslationUnit, unk1: CXFile) -> CXModule #foreign libclang;

clang_Module_getASTFile :: (Module: CXModule) -> CXFile #foreign libclang;

clang_Module_getParent :: (Module: CXModule) -> CXModule #foreign libclang;

clang_Module_getName :: (Module: CXModule) -> CXString #foreign libclang;

clang_Module_getFullName :: (Module: CXModule) -> CXString #foreign libclang;

clang_Module_isSystem :: (Module: CXModule) -> s32 #foreign libclang;

clang_Module_getNumTopLevelHeaders :: (unk0: CXTranslationUnit, Module: CXModule) -> u32 #foreign libclang;

clang_Module_getTopLevelHeader :: (unk0: CXTranslationUnit, Module: CXModule, Index: u32) -> CXFile #foreign libclang;

clang_CXXConstructor_isConvertingConstructor :: (C: CXCursor) -> u32 #foreign libclang;

clang_CXXConstructor_isCopyConstructor :: (C: CXCursor) -> u32 #foreign libclang;

clang_CXXConstructor_isDefaultConstructor :: (C: CXCursor) -> u32 #foreign libclang;

clang_CXXConstructor_isMoveConstructor :: (C: CXCursor) -> u32 #foreign libclang;

clang_CXXField_isMutable :: (C: CXCursor) -> u32 #foreign libclang;

clang_CXXMethod_isDefaulted :: (C: CXCursor) -> u32 #foreign libclang;

clang_CXXMethod_isPureVirtual :: (C: CXCursor) -> u32 #foreign libclang;

clang_CXXMethod_isStatic :: (C: CXCursor) -> u32 #foreign libclang;

clang_CXXMethod_isVirtual :: (C: CXCursor) -> u32 #foreign libclang;

clang_CXXRecord_isAbstract :: (C: CXCursor) -> u32 #foreign libclang;

clang_EnumDecl_isScoped :: (C: CXCursor) -> u32 #foreign libclang;

clang_CXXMethod_isConst :: (C: CXCursor) -> u32 #foreign libclang;

clang_getTemplateCursorKind :: (C: CXCursor) -> CXCursorKind #foreign libclang;

clang_getSpecializedCursorTemplate :: (C: CXCursor) -> CXCursor #foreign libclang;

clang_getCursorReferenceNameRange :: (C: CXCursor, NameFlags: u32, PieceIndex: u32) -> CXSourceRange #foreign libclang;

using CXNameRefFlags :: enum u32 {
        CXNameRange_WantQualifier :: 1;
        CXNameRange_WantTemplateArgs :: 2;
        CXNameRange_WantSinglePiece :: 4;
}

using CXTokenKind :: enum u32 {
        CXToken_Punctuation :: 0;
        CXToken_Keyword :: 1;
        CXToken_Identifier :: 2;
        CXToken_Literal :: 3;
        CXToken_Comment :: 4;
}



anon_struct_11 :: struct {
    int_data: [4] u32;
    ptr_data: *void;
}

CXToken :: anon_struct_11;

clang_getToken :: (TU: CXTranslationUnit, Location: CXSourceLocation) -> *CXToken #foreign libclang;

clang_getTokenKind :: (unk0: CXToken) -> CXTokenKind #foreign libclang;

clang_getTokenSpelling :: (unk0: CXTranslationUnit, unk1: CXToken) -> CXString #foreign libclang;

clang_getTokenLocation :: (unk0: CXTranslationUnit, unk1: CXToken) -> CXSourceLocation #foreign libclang;

clang_getTokenExtent :: (unk0: CXTranslationUnit, unk1: CXToken) -> CXSourceRange #foreign libclang;

clang_tokenize :: (TU: CXTranslationUnit, Range: CXSourceRange, Tokens: **CXToken, NumTokens: *u32) -> void #foreign libclang;

clang_annotateTokens :: (TU: CXTranslationUnit, Tokens: *CXToken, NumTokens: u32, Cursors: *CXCursor) -> void #foreign libclang;

clang_disposeTokens :: (TU: CXTranslationUnit, Tokens: *CXToken, NumTokens: u32) -> void #foreign libclang;

clang_getCursorKindSpelling :: (Kind: CXCursorKind) -> CXString #foreign libclang;

clang_getDefinitionSpellingAndExtent :: (unk0: CXCursor, startBuf: **u8, endBuf: **u8, startLine: *u32, startColumn: *u32, endLine: *u32, endColumn: *u32) -> void #foreign libclang;

clang_enableStackTraces :: () -> void #foreign libclang;

clang_executeOnThread :: (fn: #type (a0: *void) -> void #c_call, user_data: *void, stack_size: u32) -> void #foreign libclang;

CXCompletionString :: *void;

anon_struct_12 :: struct {
    CursorKind: CXCursorKind;
    CompletionString: CXCompletionString;
}

CXCompletionResult :: anon_struct_12;

using CXCompletionChunkKind :: enum u32 {
        CXCompletionChunk_Optional :: 0;
        CXCompletionChunk_TypedText :: 1;
        CXCompletionChunk_Text :: 2;
        CXCompletionChunk_Placeholder :: 3;
        CXCompletionChunk_Informative :: 4;
        CXCompletionChunk_CurrentParameter :: 5;
        CXCompletionChunk_LeftParen :: 6;
        CXCompletionChunk_RightParen :: 7;
        CXCompletionChunk_LeftBracket :: 8;
        CXCompletionChunk_RightBracket :: 9;
        CXCompletionChunk_LeftBrace :: 10;
        CXCompletionChunk_RightBrace :: 11;
        CXCompletionChunk_LeftAngle :: 12;
        CXCompletionChunk_RightAngle :: 13;
        CXCompletionChunk_Comma :: 14;
        CXCompletionChunk_ResultType :: 15;
        CXCompletionChunk_Colon :: 16;
        CXCompletionChunk_SemiColon :: 17;
        CXCompletionChunk_Equal :: 18;
        CXCompletionChunk_HorizontalSpace :: 19;
        CXCompletionChunk_VerticalSpace :: 20;
}

clang_getCompletionChunkKind :: (completion_string: CXCompletionString, chunk_number: u32) -> CXCompletionChunkKind #foreign libclang;

clang_getCompletionChunkText :: (completion_string: CXCompletionString, chunk_number: u32) -> CXString #foreign libclang;

clang_getCompletionChunkCompletionString :: (completion_string: CXCompletionString, chunk_number: u32) -> CXCompletionString #foreign libclang;

clang_getNumCompletionChunks :: (completion_string: CXCompletionString) -> u32 #foreign libclang;

clang_getCompletionPriority :: (completion_string: CXCompletionString) -> u32 #foreign libclang;

clang_getCompletionAvailability :: (completion_string: CXCompletionString) -> CXAvailabilityKind #foreign libclang;

clang_getCompletionNumAnnotations :: (completion_string: CXCompletionString) -> u32 #foreign libclang;

clang_getCompletionAnnotation :: (completion_string: CXCompletionString, annotation_number: u32) -> CXString #foreign libclang;

clang_getCompletionParent :: (completion_string: CXCompletionString, kind: *CXCursorKind) -> CXString #foreign libclang;

clang_getCompletionBriefComment :: (completion_string: CXCompletionString) -> CXString #foreign libclang;

clang_getCursorCompletionString :: (cursor: CXCursor) -> CXCompletionString #foreign libclang;

anon_struct_13 :: struct {
    Results: *CXCompletionResult;
    NumResults: u32;
}

CXCodeCompleteResults :: anon_struct_13;

clang_getCompletionNumFixIts :: (results: *CXCodeCompleteResults, completion_index: u32) -> u32 #foreign libclang;

clang_getCompletionFixIt :: (results: *CXCodeCompleteResults, completion_index: u32, fixit_index: u32, replacement_range: *CXSourceRange) -> CXString #foreign libclang;

using CXCodeComplete_Flags :: enum u32 {
        CXCodeComplete_IncludeMacros :: 1;
        CXCodeComplete_IncludeCodePatterns :: 2;
        CXCodeComplete_IncludeBriefComments :: 4;
        CXCodeComplete_SkipPreamble :: 8;
        CXCodeComplete_IncludeCompletionsWithFixIts :: 16;
}

using CXCompletionContext :: enum u32 {
        CXCompletionContext_Unexposed :: 0;
        CXCompletionContext_AnyType :: 1;
        CXCompletionContext_AnyValue :: 2;
        CXCompletionContext_ObjCObjectValue :: 4;
        CXCompletionContext_ObjCSelectorValue :: 8;
        CXCompletionContext_CXXClassTypeValue :: 16;
        CXCompletionContext_DotMemberAccess :: 32;
        CXCompletionContext_ArrowMemberAccess :: 64;
        CXCompletionContext_ObjCPropertyAccess :: 128;
        CXCompletionContext_EnumTag :: 256;
        CXCompletionContext_UnionTag :: 512;
        CXCompletionContext_StructTag :: 1024;
        CXCompletionContext_ClassTag :: 2048;
        CXCompletionContext_Namespace :: 4096;
        CXCompletionContext_NestedNameSpecifier :: 8192;
        CXCompletionContext_ObjCInterface :: 16384;
        CXCompletionContext_ObjCProtocol :: 32768;
        CXCompletionContext_ObjCCategory :: 65536;
        CXCompletionContext_ObjCInstanceMessage :: 131072;
        CXCompletionContext_ObjCClassMessage :: 262144;
        CXCompletionContext_ObjCSelectorName :: 524288;
        CXCompletionContext_MacroName :: 1048576;
        CXCompletionContext_NaturalLanguage :: 2097152;
        CXCompletionContext_IncludedFile :: 4194304;
        CXCompletionContext_Unknown :: 8388607;
}

clang_defaultCodeCompleteOptions :: () -> u32 #foreign libclang;

clang_codeCompleteAt :: (TU: CXTranslationUnit, complete_filename: *u8, complete_line: u32, complete_column: u32, unsaved_files: *CXUnsavedFile, num_unsaved_files: u32, options: u32) -> *CXCodeCompleteResults #foreign libclang;

clang_sortCodeCompletionResults :: (Results: *CXCompletionResult, NumResults: u32) -> void #foreign libclang;

clang_disposeCodeCompleteResults :: (Results: *CXCodeCompleteResults) -> void #foreign libclang;

clang_codeCompleteGetNumDiagnostics :: (Results: *CXCodeCompleteResults) -> u32 #foreign libclang;

clang_codeCompleteGetDiagnostic :: (Results: *CXCodeCompleteResults, Index: u32) -> CXDiagnostic #foreign libclang;

clang_codeCompleteGetContexts :: (Results: *CXCodeCompleteResults) -> u64 #foreign libclang;

clang_codeCompleteGetContainerKind :: (Results: *CXCodeCompleteResults, IsIncomplete: *u32) -> CXCursorKind #foreign libclang;

clang_codeCompleteGetContainerUSR :: (Results: *CXCodeCompleteResults) -> CXString #foreign libclang;

clang_codeCompleteGetObjCSelector :: (Results: *CXCodeCompleteResults) -> CXString #foreign libclang;

clang_getClangVersion :: () -> CXString #foreign libclang;

clang_toggleCrashRecovery :: (isEnabled: u32) -> void #foreign libclang;

CXInclusionVisitor :: #type (a0: CXFile, a1: *CXSourceLocation, a2: u32, a3: CXClientData) -> void #c_call;

clang_getInclusions :: (tu: CXTranslationUnit, visitor: CXInclusionVisitor, client_data: CXClientData) -> void #foreign libclang;

using anon_enum_14 :: enum u32 {
        CXEval_Int :: 1;
        CXEval_Float :: 2;
        CXEval_ObjCStrLiteral :: 3;
        CXEval_StrLiteral :: 4;
        CXEval_CFStr :: 5;
        CXEval_Other :: 6;
        CXEval_UnExposed :: 0;
}

CXEvalResultKind :: anon_enum_14;

CXEvalResult :: *void;

clang_Cursor_Evaluate :: (C: CXCursor) -> CXEvalResult #foreign libclang;

clang_EvalResult_getKind :: (E: CXEvalResult) -> CXEvalResultKind #foreign libclang;

clang_EvalResult_getAsInt :: (E: CXEvalResult) -> s32 #foreign libclang;

clang_EvalResult_getAsLongLong :: (E: CXEvalResult) -> s64 #foreign libclang;

clang_EvalResult_isUnsignedInt :: (E: CXEvalResult) -> u32 #foreign libclang;

clang_EvalResult_getAsUnsigned :: (E: CXEvalResult) -> u64 #foreign libclang;

clang_EvalResult_getAsDouble :: (E: CXEvalResult) -> float64 #foreign libclang;

clang_EvalResult_getAsStr :: (E: CXEvalResult) -> *u8 #foreign libclang;

clang_EvalResult_dispose :: (E: CXEvalResult) -> void #foreign libclang;

CXRemapping :: *void;

clang_getRemappings :: (path: *u8) -> CXRemapping #foreign libclang;

clang_getRemappingsFromFileList :: (filePaths: **u8, numFiles: u32) -> CXRemapping #foreign libclang;

clang_remap_getNumFiles :: (unk0: CXRemapping) -> u32 #foreign libclang;

clang_remap_getFilenames :: (unk0: CXRemapping, index: u32, original: *CXString, transformed: *CXString) -> void #foreign libclang;

clang_remap_dispose :: (unk0: CXRemapping) -> void #foreign libclang;

using CXVisitorResult :: enum u32 {
        CXVisit_Break :: 0;
        CXVisit_Continue :: 1;
}

CXCursorAndRangeVisitor :: struct {
    _context: *void;
    visit: #type (a0: *void, a1: CXCursor, a2: CXSourceRange) -> CXVisitorResult #c_call;
}



using anon_enum_15 :: enum u32 {
        CXResult_Success :: 0;
        CXResult_Invalid :: 1;
        CXResult_VisitBreak :: 2;
}

CXResult :: anon_enum_15;

clang_findReferencesInFile :: (cursor: CXCursor, file: CXFile, visitor: CXCursorAndRangeVisitor) -> CXResult #foreign libclang;

clang_findIncludesInFile :: (TU: CXTranslationUnit, file: CXFile, visitor: CXCursorAndRangeVisitor) -> CXResult #foreign libclang;

CXIdxClientFile :: *void;

CXIdxClientEntity :: *void;

CXIdxClientContainer :: *void;

CXIdxClientASTFile :: *void;

anon_struct_16 :: struct {
    ptr_data: [2] *void;
    int_data: u32;
}

CXIdxLoc :: anon_struct_16;

anon_struct_17 :: struct {
    hashLoc: CXIdxLoc;
    filename: *u8;
    file: CXFile;
    isImport: s32;
    isAngled: s32;
    isModuleImport: s32;
}

CXIdxIncludedFileInfo :: anon_struct_17;

anon_struct_18 :: struct {
    file: CXFile;
    module: CXModule;
    loc: CXIdxLoc;
    isImplicit: s32;
}

CXIdxImportedASTFileInfo :: anon_struct_18;

using anon_enum_19 :: enum u32 {
        CXIdxEntity_Unexposed :: 0;
        CXIdxEntity_Typedef :: 1;
        CXIdxEntity_Function :: 2;
        CXIdxEntity_Variable :: 3;
        CXIdxEntity_Field :: 4;
        CXIdxEntity_EnumConstant :: 5;
        CXIdxEntity_ObjCClass :: 6;
        CXIdxEntity_ObjCProtocol :: 7;
        CXIdxEntity_ObjCCategory :: 8;
        CXIdxEntity_ObjCInstanceMethod :: 9;
        CXIdxEntity_ObjCClassMethod :: 10;
        CXIdxEntity_ObjCProperty :: 11;
        CXIdxEntity_ObjCIvar :: 12;
        CXIdxEntity_Enum :: 13;
        CXIdxEntity_Struct :: 14;
        CXIdxEntity_Union :: 15;
        CXIdxEntity_CXXClass :: 16;
        CXIdxEntity_CXXNamespace :: 17;
        CXIdxEntity_CXXNamespaceAlias :: 18;
        CXIdxEntity_CXXStaticVariable :: 19;
        CXIdxEntity_CXXStaticMethod :: 20;
        CXIdxEntity_CXXInstanceMethod :: 21;
        CXIdxEntity_CXXConstructor :: 22;
        CXIdxEntity_CXXDestructor :: 23;
        CXIdxEntity_CXXConversionFunction :: 24;
        CXIdxEntity_CXXTypeAlias :: 25;
        CXIdxEntity_CXXInterface :: 26;
}

CXIdxEntityKind :: anon_enum_19;

using anon_enum_20 :: enum u32 {
        CXIdxEntityLang_None :: 0;
        CXIdxEntityLang_C :: 1;
        CXIdxEntityLang_ObjC :: 2;
        CXIdxEntityLang_CXX :: 3;
        CXIdxEntityLang_Swift :: 4;
}

CXIdxEntityLanguage :: anon_enum_20;

using anon_enum_21 :: enum u32 {
        CXIdxEntity_NonTemplate :: 0;
        CXIdxEntity_Template :: 1;
        CXIdxEntity_TemplatePartialSpecialization :: 2;
        CXIdxEntity_TemplateSpecialization :: 3;
}

CXIdxEntityCXXTemplateKind :: anon_enum_21;

using anon_enum_22 :: enum u32 {
        CXIdxAttr_Unexposed :: 0;
        CXIdxAttr_IBAction :: 1;
        CXIdxAttr_IBOutlet :: 2;
        CXIdxAttr_IBOutletCollection :: 3;
}

CXIdxAttrKind :: anon_enum_22;

anon_struct_23 :: struct {
    kind: CXIdxAttrKind;
    cursor: CXCursor;
    loc: CXIdxLoc;
}

CXIdxAttrInfo :: anon_struct_23;

anon_struct_24 :: struct {
    kind: CXIdxEntityKind;
    templateKind: CXIdxEntityCXXTemplateKind;
    lang: CXIdxEntityLanguage;
    name: *u8;
    USR: *u8;
    cursor: CXCursor;
    attributes: **CXIdxAttrInfo;
    numAttributes: u32;
}

CXIdxEntityInfo :: anon_struct_24;

anon_struct_25 :: struct {
    cursor: CXCursor;
}

CXIdxContainerInfo :: anon_struct_25;

anon_struct_26 :: struct {
    attrInfo: *CXIdxAttrInfo;
    objcClass: *CXIdxEntityInfo;
    classCursor: CXCursor;
    classLoc: CXIdxLoc;
}

CXIdxIBOutletCollectionAttrInfo :: anon_struct_26;

using anon_enum_27 :: enum u32 {
        CXIdxDeclFlag_Skipped :: 1;
}

CXIdxDeclInfoFlags :: anon_enum_27;

anon_struct_28 :: struct {
    entityInfo: *CXIdxEntityInfo;
    cursor: CXCursor;
    loc: CXIdxLoc;
    semanticContainer: *CXIdxContainerInfo;
    lexicalContainer: *CXIdxContainerInfo;
    isRedeclaration: s32;
    isDefinition: s32;
    isContainer: s32;
    declAsContainer: *CXIdxContainerInfo;
    isImplicit: s32;
    attributes: **CXIdxAttrInfo;
    numAttributes: u32;
    flags: u32;
}

CXIdxDeclInfo :: anon_struct_28;

using anon_enum_29 :: enum u32 {
        CXIdxObjCContainer_ForwardRef :: 0;
        CXIdxObjCContainer_Interface :: 1;
        CXIdxObjCContainer_Implementation :: 2;
}

CXIdxObjCContainerKind :: anon_enum_29;

anon_struct_30 :: struct {
    declInfo: *CXIdxDeclInfo;
    kind: CXIdxObjCContainerKind;
}

CXIdxObjCContainerDeclInfo :: anon_struct_30;

anon_struct_31 :: struct {
    base: *CXIdxEntityInfo;
    cursor: CXCursor;
    loc: CXIdxLoc;
}

CXIdxBaseClassInfo :: anon_struct_31;

anon_struct_32 :: struct {
    protocol: *CXIdxEntityInfo;
    cursor: CXCursor;
    loc: CXIdxLoc;
}

CXIdxObjCProtocolRefInfo :: anon_struct_32;

anon_struct_33 :: struct {
    protocols: **CXIdxObjCProtocolRefInfo;
    numProtocols: u32;
}

CXIdxObjCProtocolRefListInfo :: anon_struct_33;

anon_struct_34 :: struct {
    containerInfo: *CXIdxObjCContainerDeclInfo;
    superInfo: *CXIdxBaseClassInfo;
    protocols: *CXIdxObjCProtocolRefListInfo;
}

CXIdxObjCInterfaceDeclInfo :: anon_struct_34;

anon_struct_35 :: struct {
    containerInfo: *CXIdxObjCContainerDeclInfo;
    objcClass: *CXIdxEntityInfo;
    classCursor: CXCursor;
    classLoc: CXIdxLoc;
    protocols: *CXIdxObjCProtocolRefListInfo;
}

CXIdxObjCCategoryDeclInfo :: anon_struct_35;

anon_struct_36 :: struct {
    declInfo: *CXIdxDeclInfo;
    getter: *CXIdxEntityInfo;
    setter: *CXIdxEntityInfo;
}

CXIdxObjCPropertyDeclInfo :: anon_struct_36;

anon_struct_37 :: struct {
    declInfo: *CXIdxDeclInfo;
    bases: **CXIdxBaseClassInfo;
    numBases: u32;
}

CXIdxCXXClassDeclInfo :: anon_struct_37;

using anon_enum_38 :: enum u32 {
        CXIdxEntityRef_Direct :: 1;
        CXIdxEntityRef_Implicit :: 2;
}

CXIdxEntityRefKind :: anon_enum_38;

using anon_enum_39 :: enum u32 {
        CXSymbolRole_None :: 0;
        CXSymbolRole_Declaration :: 1;
        CXSymbolRole_Definition :: 2;
        CXSymbolRole_Reference :: 4;
        CXSymbolRole_Read :: 8;
        CXSymbolRole_Write :: 16;
        CXSymbolRole_Call :: 32;
        CXSymbolRole_Dynamic :: 64;
        CXSymbolRole_AddressOf :: 128;
        CXSymbolRole_Implicit :: 256;
}

CXSymbolRole :: anon_enum_39;

anon_struct_40 :: struct {
    kind: CXIdxEntityRefKind;
    cursor: CXCursor;
    loc: CXIdxLoc;
    referencedEntity: *CXIdxEntityInfo;
    parentEntity: *CXIdxEntityInfo;
    container: *CXIdxContainerInfo;
    role: CXSymbolRole;
}

CXIdxEntityRefInfo :: anon_struct_40;

anon_struct_41 :: struct {
    abortQuery: #type (a0: CXClientData, a1: *void) -> s32 #c_call;
    diagnostic: #type (a0: CXClientData, a1: CXDiagnosticSet, a2: *void) -> void #c_call;
    enteredMainFile: #type (a0: CXClientData, a1: CXFile, a2: *void) -> CXIdxClientFile #c_call;
    ppIncludedFile: #type (a0: CXClientData, a1: *CXIdxIncludedFileInfo) -> CXIdxClientFile #c_call;
    importedASTFile: #type (a0: CXClientData, a1: *CXIdxImportedASTFileInfo) -> CXIdxClientASTFile #c_call;
    startedTranslationUnit: #type (a0: CXClientData, a1: *void) -> CXIdxClientContainer #c_call;
    indexDeclaration: #type (a0: CXClientData, a1: *CXIdxDeclInfo) -> void #c_call;
    indexEntityReference: #type (a0: CXClientData, a1: *CXIdxEntityRefInfo) -> void #c_call;
}

IndexerCallbacks :: anon_struct_41;

clang_index_isEntityObjCContainerKind :: (unk0: CXIdxEntityKind) -> s32 #foreign libclang;

clang_index_getObjCContainerDeclInfo :: (unk0: *CXIdxDeclInfo) -> *CXIdxObjCContainerDeclInfo #foreign libclang;

clang_index_getObjCInterfaceDeclInfo :: (unk0: *CXIdxDeclInfo) -> *CXIdxObjCInterfaceDeclInfo #foreign libclang;

clang_index_getObjCCategoryDeclInfo :: (unk0: *CXIdxDeclInfo) -> *CXIdxObjCCategoryDeclInfo #foreign libclang;

clang_index_getObjCProtocolRefListInfo :: (unk0: *CXIdxDeclInfo) -> *CXIdxObjCProtocolRefListInfo #foreign libclang;

clang_index_getObjCPropertyDeclInfo :: (unk0: *CXIdxDeclInfo) -> *CXIdxObjCPropertyDeclInfo #foreign libclang;

clang_index_getIBOutletCollectionAttrInfo :: (unk0: *CXIdxAttrInfo) -> *CXIdxIBOutletCollectionAttrInfo #foreign libclang;

clang_index_getCXXClassDeclInfo :: (unk0: *CXIdxDeclInfo) -> *CXIdxCXXClassDeclInfo #foreign libclang;

clang_index_getClientContainer :: (unk0: *CXIdxContainerInfo) -> CXIdxClientContainer #foreign libclang;

clang_index_setClientContainer :: (unk0: *CXIdxContainerInfo, unk1: CXIdxClientContainer) -> void #foreign libclang;

clang_index_getClientEntity :: (unk0: *CXIdxEntityInfo) -> CXIdxClientEntity #foreign libclang;

clang_index_setClientEntity :: (unk0: *CXIdxEntityInfo, unk1: CXIdxClientEntity) -> void #foreign libclang;

CXIndexAction :: *void;

clang_IndexAction_create :: (CIdx: CXIndex) -> CXIndexAction #foreign libclang;

clang_IndexAction_dispose :: (unk0: CXIndexAction) -> void #foreign libclang;

using anon_enum_42 :: enum u32 {
        CXIndexOpt_None :: 0;
        CXIndexOpt_SuppressRedundantRefs :: 1;
        CXIndexOpt_IndexFunctionLocalSymbols :: 2;
        CXIndexOpt_IndexImplicitTemplateInstantiations :: 4;
        CXIndexOpt_SuppressWarnings :: 8;
        CXIndexOpt_SkipParsedBodiesInSession :: 16;
}

CXIndexOptFlags :: anon_enum_42;

clang_indexSourceFile :: (unk0: CXIndexAction, client_data: CXClientData, index_callbacks: *IndexerCallbacks, index_callbacks_size: u32, index_options: u32, source_filename: *u8, command_line_args: **u8, num_command_line_args: s32, unsaved_files: *CXUnsavedFile, num_unsaved_files: u32, out_TU: *CXTranslationUnit, TU_options: u32) -> s32 #foreign libclang;

clang_indexSourceFileFullArgv :: (unk0: CXIndexAction, client_data: CXClientData, index_callbacks: *IndexerCallbacks, index_callbacks_size: u32, index_options: u32, source_filename: *u8, command_line_args: **u8, num_command_line_args: s32, unsaved_files: *CXUnsavedFile, num_unsaved_files: u32, out_TU: *CXTranslationUnit, TU_options: u32) -> s32 #foreign libclang;

clang_indexTranslationUnit :: (unk0: CXIndexAction, client_data: CXClientData, index_callbacks: *IndexerCallbacks, index_callbacks_size: u32, index_options: u32, unk1: CXTranslationUnit) -> s32 #foreign libclang;

clang_indexLoc_getFileLocation :: (loc: CXIdxLoc, indexFile: *CXIdxClientFile, file: *CXFile, line: *u32, column: *u32, offset: *u32) -> void #foreign libclang;

clang_indexLoc_getCXSourceLocation :: (loc: CXIdxLoc) -> CXSourceLocation #foreign libclang;

CXFieldVisitor :: #type (a0: CXCursor, a1: CXClientData) -> CXVisitorResult #c_call;

clang_Type_visitFields :: (T: CXType, visitor: CXFieldVisitor, client_data: CXClientData) -> u32 #foreign libclang;

