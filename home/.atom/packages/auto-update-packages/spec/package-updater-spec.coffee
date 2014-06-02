PackageUpdater = require '../lib/package-updater'
require './spec-helper'

describe 'PackageUpdater', ->
  beforeEach ->
    prepareCleanEnvironment()

  afterEach ->
    restoreEnvironment()

  describe '.parseLog', ->
    entries = null

    describe 'when some updates are done', ->
      beforeEach ->
        log = [
          'Package Updates Available (2)'
          '└── atom-lint 0.8.0 -> 0.8.1'
          '└── sort-lines 0.1.0 -> 0.3.0'
          ''
          'Installing atom-lint@0.8.1 to /Users/me/.atom/packages ✓'
          'Installing sort-lines@0.3.0 to /Users/me/.atom/packages ✗'
        ].join('\n')

        # "package" is a reserved word in ECMAScript
        entries = PackageUpdater.parseLog(log)

      it 'returns entries of package installation', ->
        expect(entries.length).toBe(2)

      it 'extracts package name', ->
        expect(entries[0].name).toBe('atom-lint')
        expect(entries[1].name).toBe('sort-lines')

      it 'extracts package version', ->
        expect(entries[0].version).toBe('0.8.1')
        expect(entries[1].version).toBe('0.3.0')

      it 'recognizes success and failure', ->
        expect(entries[0].isInstalled).toBe(true)
        expect(entries[1].isInstalled).toBe(false)

    describe "when there's no update", ->
      beforeEach ->
        log = [
          'Package Updates Available (0)'
          '└── (empty)'
        ].join('\n')

        entries = PackageUpdater.parseLog(log)

      it 'returns empty array', ->
        expect(entries.length).toBe(0)

    describe "when nothing is in the log", ->
      beforeEach ->
        entries = PackageUpdater.parseLog('')

      it 'returns empty array', ->
        expect(entries.length).toBe(0)

  describe '.generateSummary', ->
    describe 'when no package is updated', ->
      it 'returns null', ->
        entries = [
          { name: 'atom-lint',  isInstalled: false }
        ]
        summary = PackageUpdater.generateSummary(entries)
        expect(summary).toBeNull()

    describe 'when a packages is updated', ->
      it 'mentions the packages name', ->
        entries = [
          { name: 'atom-lint',  isInstalled: true }
        ]
        summary = PackageUpdater.generateSummary(entries)
        expect(summary).toBe('atom-lint has been updated automatically.')

    describe 'when 2 packages are updated', ->
      it 'handles conjugation properly', ->
        entries = [
          { name: 'atom-lint',  isInstalled: true }
          { name: 'sort-lines', isInstalled: true }
        ]
        summary = PackageUpdater.generateSummary(entries)
        expect(summary).toBe('atom-lint and sort-lines have been updated automatically.')

    describe 'when more than 2 packages are updated', ->
      it 'lists the packages names properly', ->
        entries = [
          { name: 'atom-lint',        isInstalled: true }
          { name: 'sort-lines',       isInstalled: true }
          { name: 'language-slim',    isInstalled: true }
          { name: 'language-haskell', isInstalled: true }
        ]
        summary = PackageUpdater.generateSummary(entries)
        expect(summary).toBe('atom-lint, sort-lines, language-slim and language-haskell ' +
                             'have been updated automatically.')

    describe 'when more than 5 packages are updated', ->
      it 'omits the package names', ->
        entries = [
          { name: 'atom-lint',        isInstalled: true }
          { name: 'sort-lines',       isInstalled: true }
          { name: 'language-slim',    isInstalled: true }
          { name: 'language-haskell', isInstalled: true }
          { name: 'language-ruby',    isInstalled: true }
          { name: 'language-python',  isInstalled: true }
        ]
        summary = PackageUpdater.generateSummary(entries)
        expect(summary).toBe('6 packages have been updated automatically.')

    describe 'when non-auto-update', ->
      it 'does not say "automatically"', ->
        entries = [
          { name: 'atom-lint',  isInstalled: true }
        ]
        summary = PackageUpdater.generateSummary(entries, false)
        expect(summary).toBe('atom-lint has been updated.')
