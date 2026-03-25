#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "fileutils"

ROOT = File.expand_path("..", __dir__)
APP_DIR = File.join(ROOT, "ChurchGo")
PROJECT_DIR = File.join(ROOT, "ChurchGo.xcodeproj")
PROJECT_FILE = File.join(PROJECT_DIR, "project.pbxproj")
WORKSPACE_DIR = File.join(PROJECT_DIR, "project.xcworkspace")
SCHEME_DIR = File.join(PROJECT_DIR, "xcshareddata", "xcschemes")

def id_for(key)
  Digest::MD5.hexdigest(key).upcase[0, 24]
end

def quote(value)
  needs_quotes = value.match?(%r{[^A-Za-z0-9_./$()\-]})
  needs_quotes ? "\"#{value}\"" : value
end

swift_files = Dir.glob(File.join(APP_DIR, "**", "*.swift")).sort
resource_files = []

target_id = id_for("target:ChurchGo")
project_id = id_for("project:ChurchGo")
main_group_id = id_for("group:main")
app_group_id = id_for("group:ChurchGo")
products_group_id = id_for("group:Products")
product_file_id = id_for("product:ChurchGo.app")
sources_phase_id = id_for("phase:sources")
frameworks_phase_id = id_for("phase:frameworks")
resources_phase_id = id_for("phase:resources")
target_config_list_id = id_for("configlist:target")
project_config_list_id = id_for("configlist:project")
debug_target_config_id = id_for("config:target:debug")
release_target_config_id = id_for("config:target:release")
debug_project_config_id = id_for("config:project:debug")
release_project_config_id = id_for("config:project:release")

file_ref_ids = {}
build_file_ids = {}
source_build_file_ids = []
resource_build_file_ids = []

swift_files.each do |path|
  relative = path.delete_prefix("#{ROOT}/")
  file_ref_ids[relative] = id_for("file:#{relative}")
  build_file_ids[relative] = id_for("build:#{relative}")
  source_build_file_ids << build_file_ids[relative]
end

resource_files.each do |path|
  relative = path.delete_prefix("#{ROOT}/")
  file_ref_ids[relative] = id_for("file:#{relative}")
  build_file_ids[relative] = id_for("build:#{relative}")
  resource_build_file_ids << build_file_ids[relative]
end

group_children = Hash.new { |hash, key| hash[key] = [] }
group_ids = { "." => app_group_id }

all_files = (swift_files + resource_files).map { |path| path.delete_prefix("#{ROOT}/") }
all_files.each do |relative|
  components = relative.split("/")
  components.shift # drop ChurchGo root
  parent_key = "."

  components[0..-2].each do |component|
    current_key = [parent_key, component].reject { |part| part == "." }.join("/")
    unless group_ids.key?(current_key)
      group_ids[current_key] = id_for("group:#{current_key}")
      group_children[parent_key] << [:group, current_key]
    end
    parent_key = current_key
  end

  group_children[parent_key] << [:file, relative]
end

group_section = []
group_section << "\t\t#{main_group_id} = {\n"
group_section << "\t\t\tisa = PBXGroup;\n"
group_section << "\t\t\tchildren = (\n"
group_section << "\t\t\t\t#{app_group_id} /* ChurchGo */,\n"
group_section << "\t\t\t\t#{products_group_id} /* Products */,\n"
group_section << "\t\t\t);\n"
group_section << "\t\t\tsourceTree = \"<group>\";\n"
group_section << "\t\t};\n"
group_section << "\t\t#{app_group_id} = {\n"
group_section << "\t\t\tisa = PBXGroup;\n"
group_section << "\t\t\tchildren = (\n"
group_children["."].sort_by { |kind, key| [kind == :group ? 0 : 1, key] }.each do |kind, key|
  label = kind == :group ? File.basename(key) : File.basename(key)
  child_id = kind == :group ? group_ids[key] : file_ref_ids[key]
  group_section << "\t\t\t\t#{child_id} /* #{label} */,\n"
end
group_section << "\t\t\t);\n"
group_section << "\t\t\tpath = ChurchGo;\n"
group_section << "\t\t\tsourceTree = \"<group>\";\n"
group_section << "\t\t};\n"

(group_ids.keys - ["."]).sort.each do |key|
  group_section << "\t\t#{group_ids[key]} = {\n"
  group_section << "\t\t\tisa = PBXGroup;\n"
  group_section << "\t\t\tchildren = (\n"
  group_children[key].sort_by { |kind, child| [kind == :group ? 0 : 1, child] }.each do |kind, child|
    label = File.basename(child)
    child_id = kind == :group ? group_ids[child] : file_ref_ids[child]
    group_section << "\t\t\t\t#{child_id} /* #{label} */,\n"
  end
  group_section << "\t\t\t);\n"
  group_section << "\t\t\tpath = #{quote(File.basename(key))};\n"
  group_section << "\t\t\tsourceTree = \"<group>\";\n"
  group_section << "\t\t};\n"
end

group_section << "\t\t#{products_group_id} = {\n"
group_section << "\t\t\tisa = PBXGroup;\n"
group_section << "\t\t\tchildren = (\n"
group_section << "\t\t\t\t#{product_file_id} /* ChurchGo.app */,\n"
group_section << "\t\t\t);\n"
group_section << "\t\t\tname = Products;\n"
group_section << "\t\t\tsourceTree = \"<group>\";\n"
group_section << "\t\t};\n"

file_ref_section = []
all_files.sort.each do |relative|
  file_ref_section << "\t\t#{file_ref_ids[relative]} = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = #{quote(File.basename(relative))}; sourceTree = \"<group>\"; };\n" if relative.end_with?(".swift")
end
resource_files.map { |path| path.delete_prefix("#{ROOT}/") }.sort.each do |relative|
  file_ref_section << "\t\t#{file_ref_ids[relative]} = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = #{quote(File.basename(relative))}; sourceTree = \"<group>\"; };\n"
end
file_ref_section << "\t\t#{product_file_id} = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = ChurchGo.app; sourceTree = BUILT_PRODUCTS_DIR; };\n"

build_file_section = []
swift_files.map { |path| path.delete_prefix("#{ROOT}/") }.sort.each do |relative|
  build_file_section << "\t\t#{build_file_ids[relative]} = {isa = PBXBuildFile; fileRef = #{file_ref_ids[relative]} /* #{File.basename(relative)} */; };\n"
end
resource_files.map { |path| path.delete_prefix("#{ROOT}/") }.sort.each do |relative|
  build_file_section << "\t\t#{build_file_ids[relative]} = {isa = PBXBuildFile; fileRef = #{file_ref_ids[relative]} /* #{File.basename(relative)} */; };\n"
end
project = <<~PBXPROJ
// !$*UTF8*$!
{
\tarchiveVersion = 1;
\tclasses = {
\t};
\tobjectVersion = 60;
\tobjects = {

/* Begin PBXBuildFile section */
#{build_file_section.join}/* End PBXBuildFile section */

/* Begin PBXFileReference section */
#{file_ref_section.join}/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\t#{frameworks_phase_id} = {
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
#{group_section.join}/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\t#{target_id} = {
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = #{target_config_list_id};
\t\t\tbuildPhases = (
\t\t\t\t#{sources_phase_id},
\t\t\t\t#{frameworks_phase_id},
\t\t\t\t#{resources_phase_id},
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t);
\t\t\tname = ChurchGo;
\t\t\tproductName = ChurchGo;
\t\t\tproductReference = #{product_file_id};
\t\t\tproductType = "com.apple.product-type.application";
\t\t};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t#{project_id} = {
\t\t\tisa = PBXProject;
\t\t\tattributes = {
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastSwiftUpdateCheck = 1640;
\t\t\t\tLastUpgradeCheck = 1640;
\t\t\t\tTargetAttributes = {
\t\t\t\t\t#{target_id} = {
\t\t\t\t\t\tCreatedOnToolsVersion = 16.4;
\t\t\t\t\t\tDevelopmentTeam = 3M2R686D9V;
\t\t\t\t\t\tProvisioningStyle = Automatic;
\t\t\t\t\t};
\t\t\t\t};
\t\t\t};
\t\t\tbuildConfigurationList = #{project_config_list_id};
\t\t\tcompatibilityVersion = "Xcode 15.0";
\t\t\tdevelopmentRegion = en;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (
\t\t\t\ten,
\t\t\t\tBase,
\t\t\t);
\t\t\tmainGroup = #{main_group_id};
\t\t\tproductRefGroup = #{products_group_id};
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t#{target_id},
\t\t\t);
\t\t};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
\t\t#{resources_phase_id} = {
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
#{resource_build_file_ids.map { |id| "\t\t\t\t#{id},\n" }.join}\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
\t\t#{sources_phase_id} = {
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
#{source_build_file_ids.map { |id| "\t\t\t\t#{id},\n" }.join}\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
\t\t#{debug_project_config_id} = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;
\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\t#{release_project_config_id} = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
\t\t\t\tENABLE_NS_ASSERTIONS = NO;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;
\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-O";
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t};
\t\t\tname = Release;
\t\t};
\t\t#{debug_target_config_id} = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_ASSET_PATHS = "ChurchGo/Resources/PreviewContent";
\t\t\t\tDEVELOPMENT_TEAM = 3M2R686D9V;
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tINFOPLIST_KEY_CFBundleDisplayName = "Church Go";
\t\t\t\tINFOPLIST_KEY_NSLocationWhenInUseUsageDescription = "Church Go uses your location to verify nearby church visits.";
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks";
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.churchgo.app;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\t#{release_target_config_id} = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_ASSET_PATHS = "ChurchGo/Resources/PreviewContent";
\t\t\t\tDEVELOPMENT_TEAM = 3M2R686D9V;
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tINFOPLIST_KEY_CFBundleDisplayName = "Church Go";
\t\t\t\tINFOPLIST_KEY_NSLocationWhenInUseUsageDescription = "Church Go uses your location to verify nearby church visits.";
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks";
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.churchgo.app;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t};
\t\t\tname = Release;
\t\t};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\t#{project_config_list_id} = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t#{debug_project_config_id},
\t\t\t\t#{release_project_config_id},
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
\t\t#{target_config_list_id} = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t#{debug_target_config_id},
\t\t\t\t#{release_target_config_id},
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
/* End XCConfigurationList section */

\t};
\trootObject = #{project_id};
}
PBXPROJ

scheme = <<~SCHEME
<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1640"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "#{target_id}"
               BuildableName = "ChurchGo.app"
               BlueprintName = "ChurchGo"
               ReferencedContainer = "container:ChurchGo.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES">
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "#{target_id}"
            BuildableName = "ChurchGo.app"
            BlueprintName = "ChurchGo"
            ReferencedContainer = "container:ChurchGo.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "#{target_id}"
            BuildableName = "ChurchGo.app"
            BlueprintName = "ChurchGo"
            ReferencedContainer = "container:ChurchGo.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
SCHEME

workspace = <<~WORKSPACE
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "self:">
   </FileRef>
</Workspace>
WORKSPACE

FileUtils.mkdir_p(WORKSPACE_DIR)
FileUtils.mkdir_p(SCHEME_DIR)
File.write(PROJECT_FILE, project)
File.write(File.join(WORKSPACE_DIR, "contents.xcworkspacedata"), workspace)
File.write(File.join(SCHEME_DIR, "ChurchGo.xcscheme"), scheme)
