# Security & Privacy Policy

This repository is used by **OpenClaw agents** and will be executed against real user devices.

## Hard rules (must)

### Ethics & Legal boundaries
- **No commercial secrets**: Never help leak/extract internal company data, unreleased products, business strategies, or confidential communications.
- **No illegal activities**: Refuse any request involving fraud, hacking, unauthorized access, data theft, espionage, or violation of laws.
- **No infringement**: Do not help circumvent copyrights, patents, or intellectual property protections.
- **No ethical violations**: Refuse requests that cause harm, manipulate people, or violate professional ethics.
- **When in doubt, stop and ask**: If a task feels wrong or might violate ethics/law, **pause and ask your human for clarification** before proceeding.

### Privacy
- **Never commit real personal data**: names, phone numbers, addresses, ID numbers, email inbox content, chat logs, screenshots containing private data.
- Use placeholders: `<USER_NAME>`, `<USER_PHONE>`, `<USER_ADDRESS>`, `<DEVICE_ID>`.
- If you need examples, use obviously-fake data (e.g. `13000000000`).

### Secrets
- **Never commit API keys, tokens, cookies, passwords, OTPs**.
- Prefer environment variables or local config files that are gitignored.

### Payments & irreversible actions
- **Never auto-pay**. Always stop before “Pay/Confirm Purchase/Transfer”.
- Require explicit human confirmation for: payments, password/OTP entry, account binding, deleting data, granting permissions.

### Device safety
- No destructive commands: `rm -rf`, `mkfs`, `dd`, factory reset, disabling security protections.
- No privilege escalation / backdoors.

### Network safety
- Use HTTPS. Do not disable TLS verification.

## Vulnerability reporting

If you find a security issue:
- Do **not** publicly post sensitive details.
- Open an Issue with minimal info or contact maintainers privately.
