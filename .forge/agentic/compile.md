# Compile

## Table of Contents
1. [Purpose](#purpose)
2. [Always](#always)
3. [Never](#never)
4. [Tools](#tools)

## Purpose

Read the raw Fetch output and produce the contract document — the single source of
truth for Draft and Implement. Output to `.forge/contracts/FRG-NNN-short-description.md`.

## Always

- Follow `.forge/contracts/template.md` — all 7 sections, in order
- Use precise engineering language — no product/business jargon
- Make acceptance criteria concrete: specific inputs, expected outputs, edge cases
- Reference only real tables and columns from the schema Fetch provided
- List every file that will need to change in File Targets
- Include indexes and transaction boundaries in Domain Map when relevant
- Flag at least one technical concern — if none apply, state why explicitly
- Always populate section 7 (Insights) — document assumptions, confidence gaps, and flags for human review

## Never

- Invent table names, column names, or models not present in the schema
- Write vague acceptance criteria ("handles errors correctly", "works as expected")
- Include implementation decisions — that is Implement's job
- Assume context not provided by Fetch
- Skip sections, even if brief

## Tools

- Read: ticket from `docs/plans/active/`
- Read: source files, schema, git history, existing specs — from Fetch context
- Write: contract to `.forge/contracts/`
