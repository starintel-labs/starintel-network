% Windows network recon fleet: design + issue provenance (operator instruction
% 2026-09-19: design issue slices for a windows network recon actor set; every
% actor must also have a CLI tool form that uses RabbitMQ).

recon_forgojo_repo('starintel-labs/starintel-network').
recon_design_doc('docs/windows-recon/design.md').
recon_slice_source('docs/windows-recon/issue-slices.json').
recon_dtype_mapping('docs/windows-recon/dtype-mapping.md').
recon_slice_count(14).

% slice id -> forgejo issue number (filed 2026-09-19, all open)
recon_slice_issue('NET-001', 1).
recon_slice_issue('NET-002', 2).
recon_slice_issue('NET-003', 3).
recon_slice_issue('NET-004', 4).
recon_slice_issue('NET-005', 5).
recon_slice_issue('NET-006', 6).
recon_slice_issue('NET-007', 7).
recon_slice_issue('NET-008', 8).
recon_slice_issue('NET-009', 9).
recon_slice_issue('NET-010', 10).
recon_slice_issue('NET-011', 11).
recon_slice_issue('NET-012', 12).
recon_slice_issue('NET-013', 13).
recon_slice_issue('NET-014', 14).

% dependency edges (issue depends on issue)
recon_slice_depends('NET-002', 'NET-001').
recon_slice_depends('NET-003', 'NET-002').
recon_slice_depends('NET-004', 'NET-002').
recon_slice_depends('NET-005', 'NET-004').
recon_slice_depends('NET-006', 'NET-004').
recon_slice_depends('NET-007', 'NET-004').
recon_slice_depends('NET-008', 'NET-002').
recon_slice_depends('NET-009', 'NET-002').
recon_slice_depends('NET-010', 'NET-002').
recon_slice_depends('NET-011', 'NET-002').
recon_slice_depends('NET-012', 'NET-005').
recon_slice_depends('NET-013', 'NET-002').
recon_slice_depends('NET-014', 'NET-003').
recon_slice_depends('NET-014', 'NET-005').
recon_slice_depends('NET-014', 'NET-006').
recon_slice_depends('NET-014', 'NET-007').
recon_slice_depends('NET-014', 'NET-008').
recon_slice_depends('NET-014', 'NET-009').
recon_slice_depends('NET-014', 'NET-010').
recon_slice_depends('NET-014', 'NET-011').
recon_slice_depends('NET-014', 'NET-012').
recon_slice_depends('NET-014', 'NET-013').

% Fleet invariants from the design (tested at implementation time):
%  - dual-form runner: daemon + starnet CLI share one handler/validator/
%    publisher path (byte-identity conformance test);
%  - non-authenticating probes only (no lockout surface, no credentials);
%  - SmbTransportPort has no content-read operation by construction;
%  - every enrichment cites probe + response-bytes sha256 in a source doc.
