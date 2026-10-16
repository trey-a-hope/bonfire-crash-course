# Module diagrams

One Excalidraw diagram per course module, in the layout Trey approved on Module 3:
the module, one column per lesson with its key concepts, and what students finish
with (the module's completion-page achievements). Build steps and pro tips are left out.

- `module_<n>_<name>.excalidraw`: one file per module.
- `bonfire_modules_all.excalidraw`: every module as its own frame (artboard) in one scene.
- `svg/`: plain previews of each module.

The app shows each diagram on its module's overview page, from
`assets/images/module_diagrams/`. Those copies have their colors written as
attributes and plain arrowheads, so they don't rely on `<style>`, classes or `<marker>`,
which flutter_svg doesn't fully support. Introduction and Getting Started have
`"overview_page": false` in their specs, so they get no app copy or overview page.

Open a file at excalidraw.com (or import it into Excalidraw+) to view or edit it.

## Rebuilding

The content lives in `tool/diagrams/specs/module_<n>.json`, written from the lesson
pages (`lib/presentation/pages/**`) and each module's `*_module.dart`. Edit a spec,
then run (it also rewrites the app copies):

```
python3 tool/diagrams/build_module_diagrams.py
```

Only lessons with concept cards get a column. The Enemy module and the final
course-completion page have no lessons yet, so they have no diagram.
