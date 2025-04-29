---
description: Cline Rules Location Rule
globs: docs/for_ai/rules/*.md
alwaysApply: false
---
## Description
This rule ensures that all new rules are created in the `docs/for_ai/rules` directory, maintaining a consistent and organized structure for rule management.

## Rule
When creating new rules:
1. All new rules MUST be created in the `docs/for_ai/rules` directory
2. Each rule MUST be in a separate file
3. Rule files MUST use the `.md` extension
4. Rule files MUST follow the naming convention: `[rule-name].mdc`
5. Rule files MUST contain proper markdown formatting

## Implementation
- Clie will enforce this rule by:
  - Automatically creating rules in the `docs/for_ai/rules` directory
  - Preventing creation of rules outside this directory
  - Maintaining separation of rules into individual files
  - Ensuring proper file extensions and naming conventions

## Benefits
- Improved organization and maintainability
- Easier rule discovery and management
- Consistent rule structure across the project
- Better version control and tracking of rule changes

## Examples
✅ Correct:
```
docs/for_ai/rules/
  ├── rules-location.mdc
  ├── another-rule.mdc
  └── third-rule.mdc
```

❌ Incorrect:
```
.docs/
  ├── rules/
  │   └── rules-location.mdc
  └── other-rules/
      └── another-rule.mdc
``` 
