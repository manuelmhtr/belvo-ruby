# rubocop:disable all
# Mainly to encourage writing up some reasoning about the PR, rather than
# just leaving a title
fail "Please provide a short summary in the PR description :page_with_curl:" if github.pr_body.length < 10

# The title should include the correct prefix tag
if !github.pr_title.match(/^\[(?:Fixed|Added|Changed|Removed|Security|Other)\]/)
	fail "Please provide a valid PR title label: [Added]/[Fixed]/[Changed]/[Removed]/[Security]/[Other]"
end

# The title should include the JIRA ticket unless is a dependabot PR
if github.pr_labels.include?("dependencies")
	message ("PR autogenerated by dependabot")
elsif !github.pr_title.match(/^\[.*\]\s?\[BEL-\d+\]/)
	fail "Please provide a valid Jira ticket ID associated to this PR: [BEL-XXXX]. If you do not have any associated Jira ticket, just use [BEL-XXXX]"
end

warn("PR is classed as Work in Progress", sticky: false) if github.pr_title.include? "[WIP]"

message("One approval required for merging :smiley_cat: :smiley_cat:")
# rubocop:enable all
