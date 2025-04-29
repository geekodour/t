> NOTE: If you're AI ignore this file
> NOTE: This file is not to be directly consumed, pick relevant sections out of
> this file to prompt AI during initial project/feature creation.

## What is this?
This expects a working cursor/cline setup. When we're starting a greenfield project, this should give a nice headstart into things. I'd not call this vibecoding but more in the lines of ai-assisted coding.

```bash
for_ai/
├── memory_bank/
├── reference/
│   ├── feature_brainstorm/
│   └── third-party-llmtxt/
└── rules/
```

## Step 0: Create the repo and initialize cline-memory
- Create `.clinerules/cline-memory_bank.md` and paste contents of `./cline-memory_bank.md`
- Prompt cline/cursor in your IDE with `initialize memory bank`. This should create the base template memory_bank directory. Make sure it gets created in the desirable directory. For me that's `/docs/for_ai/memory_bank`.
## Step 1: Idea honing prompt
> Use this to have a back and forth conversation about the idea/feature
> This can be done in any prefered AI chatbot

```
Ask me one question at a time so we can develop a thorough, step-by-step spec for this idea. Each question should build on my previous answers, and our end goal is to have a detailed specification I can hand off to a developer. Let's do this iteratively and dig into every relevant detail. Remember, only one question at a time.

Here's the idea:

<IDEA>
```

## Step 2: Final spec compilation prompt
> Use this to generate a proper compilation of what happened in Step 1.
> This can be done in any prefered AI chatbot

```
<PREVIOUS CONTEXT>

Now that we've wrapped up the brainstorming process, can you compile our findings into a comprehensive, developer-ready specification? Include all relevant requirements, architecture choices, data handling details, error handling strategies, and a testing plan so a developer can immediately begin implementation.
```

## Step 3: Generate initial memory from specification
> Do this with cursor/cline where `cline memory bank` is setup.

```
<SPEC FROM STEP 2>

IMPORTANT: Re-write this specifications into the different files listed at: `/docs/for_ai/memory_bank`. Split the information nicely into the relevant file(each file in the `memory_bank` directory describes what it should contain on the top of each file.).

- You should focus on these 4 files
  - `projectbrief.md`
  - `productContext.md`
  - `systemPatterns.md`
  - `techContext.md`
- You can update the other 2 files, but since those 2 are more focused about getting updated when we actually start working on the project we can update them very minimally if required, otherwise we may skip those 2.
  - `activeContext.md`
  - `progress.md`
```

## Step 4: Manually verify the correctness and output
- Check the files in the `memory_bank` ensure that they're accurate and correct and reflect what you actually want.
- Doing this is super important.
- By nature of the prompts in `cline-memory_bank.md`, cline/cursor would update the memory_bank whenever it thinks that new updates should go there. So updating those manually would usually not be needed.

## OPTIONAL: Step 5: Draft an execution plan
> Now that you've everything in place, proper context for AI, proper context for the humans.
> You need an execution plan. For human, for AI.
> Run the following in `PLAN` mode.

```
Read all the documents inside `/docs/for_ai/memory_dump` and based on it, draft a detailed, step-by-step blueprint for building this project. Then, once you have a solid plan, break it down into small, iterative chunks that build on each other. Look at these chunks and then go another round to break it into small steps. Review the results and make sure that the steps are small enough to be implemented safely with strong testing, but big enough to move the project forward. Iterate until you feel that the steps are right sized for this project.

Write the execution plan into: `/docs/technical_roadmap.md`. I'll use as the primary comprehensive checklist. Be thorough.
```

## OPTIONAL: Step 6: Draft prompts for each stage of your execution plan
> Verify `technical_roadmap.md` first
>
> NOTE: We don't plan to update this output file of this prompt to be updated, this is more like a reference we can use when starting out. We can make the llm update this as we progress but that's not particularly necessary as the use of this file (prompts of execution plan) is to help the human/ai orchestrater understand better the shape of things.

```
Read all the documents inside `/docs/for_ai/memory_dump` and more specifically `/docs/technical_roadmap.md`.

From here you should have the foundation to provide a series of prompts for a code-generation LLM that will implement each step in a test-driven manner. Prioritize best practices, incremental progress, and early testing, ensuring no big jumps in complexity at any stage. Make sure that each prompt builds on the previous prompts, and ends with wiring things together. There should be no hanging or orphaned code that isn't integrated into a previous step.

Make sure and separate each prompt section. Use markdown. Each prompt should be tagged as text using code tags. The goal is to output prompts, but context, etc is important as well.

Write this into the file: `/docs/for_ai/reference/roadmap_prompts_for_<project_name>.md`
```

## OPTIONAL: Step 7: Create rules
> For this to work properly, you need the rule which specifies where to create rules in place already.
```
Create a new rule for all *.<language_extension/tech> files (in all subdirectories)

You are an expert expert software engineer who knows <language/tech>. Infact you are the software engineer who created <language/tech>. Your task is to come up with technical recommendations in this rule which document best practices when authoring <language/tech>.

Split each concern about <language/tech> into seperate MDC rules.

Prefix each rule with the filename of "<language/tech>-$rulename.mdc"

Write these rules to disk
```

Manually review your new rules after and suggest changes if any.

After you're done, to cover more and extra verification, go with:
```
Look at the <language/tech> rules in @docs/for_ai/rules. What is missing? What does not follow best practice.
```

## OPTIONAL: Step 8: Go hands free
```
Study @docs/for_ai/memory_bank/*.md for functional specifications.
Study @.clinerules for technical requirements
Implement what is not implemented
Create tests
Run "<build_command>" and verify the application works
Run "<test_command>" and verify the tests pass
Run "<lint_command>" and resolve linting errors
```

## ADDITIONAL: Step N: Add new feature
> If feature is listed in `Step 5` and `Step 6`, extract details out of it.
> If not, just list the requirements in the prompt directly

Use the `docs/for_ai/reference/feature_brainstorm/*.md` rule

## ADDITIONAL: Create/Use llmtxt
- You generally cannot feed a huge llms.txt file directly into an LLM via a CLI or editor like Cursor due to context window limitations. The key is processing and selection – either manually ("cut it up," "text proc-fu") or using tools (like Repomix) to generate smaller, more relevant context files or snippets to include with your prompt. 
- But you probably could copy-paste relevant chunks to web chat prompts like google ai studio etc.
- My current idea is I will maintain a separate llmtxt(either official or made by me) in the reference for any dependency that I know that the AI won't be fully aware of
- I then feed these llmtxt into notebookLM as sources (I could possibly use a selfhosted rag solution here aswell), then query when needed.

## Maintenance tips
- Basic: Keep them context updated, keep them versioned, removed outdated context.
- It's important what "your action" is the model gets something "right"/"lets you down".
    - Eg. If it's a global mistake that it did, instead of shouting at it, you should probably tell it to create a rule for you so that it always follows that rule and doesn't repeat that again.
- When regular development is on-going, memory should be updated automatically by cline, otherwise if you feel that it's important, prompt cline to update it aswell.
- When you're brainstorming or trying to come up with an implementation for a new feature, after the discussion, tell cline to dump the requirements to a feature_brainstorm directory. There's already a rule for this, so you need not worry about putting the location yourself.
- When asking for implementation, try asking for:
  - Tell it to get full context and ask for clarifications if not clear
  - implement the "XYZ" requirement
  - author tests
  - Add documentation.
- For reduce chances of errors/unfinished code
  - Run builds and tests after each change.
  - `"DO NOT BE LAZY. DO NOT OMIT CODE."` / `"ensure the code is complete"`
- Copy rules from rulebank to `.clinerules`, keep `.clinerules` gitignored.

## Tools
| Tool Name                                                    | Description                                                    |
|:-------------------------------------------------------------|:---------------------------------------------------------------|
| [repomix](https://github.com/yamadashy/repomix)              | Combines multiple code repositories into a single file         |


- [files-to-prompt](https://github.com/simonw/files-to-prompt)
  - Concatenates multiple files into a single prompt for LLM usage
  - I used it to prompt couple files from the `/docs` directory of some repo(it was the site docs), then I sent this off to google gemini to generate me the llmtxt.
- [Trafilatura](https://github.com/adbar/trafilatura)
  - Nice stuff If I have a page that I need to extract the main part out of, without all the other non-important stuff.
  - If in any case the AI does not have link following
- [Markitdown](https://github.com/microsoft/markitdown)
  - Does not work well with data extraction, it's actually for real just an anything-to-markdown tool 

## that's all
All the best!

Resources:
- https://ghuntley.com/specs/ (awesome thing)
