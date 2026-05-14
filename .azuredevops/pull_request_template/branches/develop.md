Provide as much detail as possible.

This template must be filled out or your PR may be rejected.

### Develop Checklist
- [ ] I am introducing small changes/additions with this PR
- [ ] I have performed `terraform fmt -recursive`
- [ ] I have generated the README.md using `terraform-docs markdown .` (--recursive if including sub-modules)
- [ ] I have updated the versions of providers, terraform cli, and shared modules
- [ ] I have performed a review with Cloud Engineering and Solution Architect(s) for major infrastructure changes/additions
- [ ] I have updated all the designs (conceptual, high/lower-Level, etc) and included them in this PR (docs/) or links in the README.md
- [ ] I have performed a self-review and team peer-review of the code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have noted on the description above any non-terraform code included in this PR (Az CLI, ARM Template, REST API, etc)
- [ ] I have ensured my deployment is entirely code-based (no manual portal-based deployments)
- [ ] I will deploy to all the environments, and once ready, create a PR to the main branch
- [ ] I will destroy my sandbox environment(s) after the resources have been reviewed
