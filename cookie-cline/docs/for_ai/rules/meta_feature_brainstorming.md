---
description: Rule for Feature Brainstorming File Location and Content
globs: docs/for_ai/reference/feature_brainstorm/*.md
alwaysApply: false
---
## Description
This rule defines the standard location, naming convention, and content guidelines for feature brainstorming files. These files capture the requirements and implementation ideas discussed during feature development brainstorming sessions.

## Rule
1.  **Location:** All feature brainstorming files MUST be created in the `docs/for_ai/reference/feature_brainstorm/` directory.
2.  **Naming Convention:** Files MUST follow the naming convention: `<feature_namespace>_<feature_name>.md`. Replace `<feature_namespace>` and `<feature_name>` with relevant identifiers for the feature.
  - namespace can be anything really, this is just and differentiator. eg. just figure out the context have have it. This is useful if we have the same feature in multiple places in the codebase, helps find things later.
3.  **Purpose:** These files serve as a reference dump of requirements and implementation details derived from brainstorming discussions.
4.  **Context Re-injection:** The content should be structured clearly to facilitate easy re-injection into the context window when revisiting the feature. eg. Use bullet points, section things into different phases/sections etc.
5. If asked to create a directory for the feature, just follow the same naming conventions and split the different parts of the feature into relevant files with relevant filenames.

## Implementation
- Cline will create brainstorming dump files in the specified location after feature discussions when requested.
- Cline will use the defined naming convention.
- Cline will structure the content for clarity and potential context re-injection.

## Benefits
- Centralized location for feature brainstorming artifacts.
- Consistent naming for easy identification.
- Preserves brainstorming context for future reference.

## Example
A brainstorming session for a new user authentication feature within the 'auth' namespace might result in a file named:
`docs/for_ai/reference/feature_brainstorm/auth_user_authentication.md`

This file would contain the discussion summary, requirements, and potential implementation approaches.
