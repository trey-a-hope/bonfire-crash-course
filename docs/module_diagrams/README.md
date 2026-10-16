# Module diagrams

One Excalidraw diagram per course module, in the layout Trey approved on Module 3:
the module, one column per lesson with its key concepts, and what students finish
with (the module's completion-page achievements). Build steps and pro tips are left out.

- `module_<n>_<name>.excalidraw`: one file per module.
- `bonfire_modules_all.excalidraw`: every module as its own frame (artboard) in one scene.
- `svg/`: plain previews of each module.

Open a file at excalidraw.com (or import it into Excalidraw+) to view or edit it.

## Rebuilding

The content lives in `tool/diagrams/specs/module_<n>.json`, written from the lesson
pages (`lib/presentation/pages/**`) and each module's `*_module.dart`. Edit a spec,
then run:

```
python3 tool/diagrams/build_module_diagrams.py
```

Only lessons with concept cards get a column. The Enemy module and the final
course-completion page have no lessons yet, so they have no diagram.
