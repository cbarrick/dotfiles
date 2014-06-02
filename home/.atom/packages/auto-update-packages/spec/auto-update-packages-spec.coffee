fs = require 'fs'
AutoUpdatePackages = require '../lib/auto-update-packages'
PackageUpdater = require '../lib/package-updater'
require './spec-helper'

describe 'auto-upgrade-packages', ->
  beforeEach ->
    prepareCleanEnvironment()

  afterEach ->
    restoreEnvironment()

  describe '.loadLastUpdateTime', ->
    describe 'when no update has done ever', ->
      beforeEach ->
        path = AutoUpdatePackages.getLastUpdateTimeFilePath()
        fs.unlinkSync(path) if fs.existsSync(path)

      it 'returns null', ->
        expect(AutoUpdatePackages.loadLastUpdateTime()).toBeNull()

    describe 'when any update has done ever', ->
      beforeEach ->
        AutoUpdatePackages.saveLastUpdateTime()

      it 'returns the time', ->
        loadedTime = AutoUpdatePackages.loadLastUpdateTime()
        now = Date.now()
        # toBeCloseTo matcher allows only decimal numbers.
        expect(loadedTime).toBeLessThan(now + 1)
        expect(loadedTime).toBeGreaterThan(now - 1000)

  describe '.updatePackagesIfAutoUpdateBlockIsExpired', ->
    describe 'when no update has done ever', ->
      beforeEach ->
        path = AutoUpdatePackages.getLastUpdateTimeFilePath()
        fs.unlinkSync(path) if fs.existsSync(path)

      it 'runs update', ->
        spyOn(AutoUpdatePackages, 'updatePackages')
        AutoUpdatePackages.updatePackagesIfAutoUpdateBlockIsExpired()
        expect(AutoUpdatePackages.updatePackages).toHaveBeenCalled()

    describe 'when a update has done just now', ->
      beforeEach ->
        spyOn(PackageUpdater, 'updatePackages')
        AutoUpdatePackages.updatePackagesIfAutoUpdateBlockIsExpired()

      it 'does not run update', ->
        spyOn(AutoUpdatePackages, 'updatePackages')
        AutoUpdatePackages.updatePackagesIfAutoUpdateBlockIsExpired()
        expect(AutoUpdatePackages.updatePackages).not.toHaveBeenCalled()

  describe '.getAutoUpdateBlockDuration', ->
    describe 'when "auto-update-packages.intervalMinutes" is not set', ->
      it 'returns 21600000 (6 hours)', ->
        expect(AutoUpdatePackages.getAutoUpdateBlockDuration()).toBe(21600000)

    describe 'when "auto-update-packages.intervalMinutes" is 30', ->
      beforeEach ->
        atom.config.set('auto-update-packages.intervalMinutes', 30)

      it 'returns 1800000', ->
        expect(AutoUpdatePackages.getAutoUpdateBlockDuration()).toBe(1800000)

    describe 'when "auto-update-packages.intervalMinutes" is 14', ->
      beforeEach ->
        atom.config.set('auto-update-packages.intervalMinutes', 14)

      it 'returns 900000 (15 minutes) to avoid too frequent access to the server', ->
        expect(AutoUpdatePackages.getAutoUpdateBlockDuration()).toBe(900000)

  describe '.getAutoUpdateCheckInterval', ->
    describe 'when "auto-update-packages.intervalMinutes" is not set', ->
      beforeEach ->
        atom.config.set('auto-update-packages.intervalMinutes', null)

      it 'returns 1440000 (24 minutes)', ->
        expect(AutoUpdatePackages.getAutoUpdateCheckInterval()).toBe(1440000)

    describe 'when "auto-update-packages.intervalMinutes" is 30', ->
      beforeEach ->
        atom.config.set('auto-update-packages.intervalMinutes', 30)

      it 'returns 120000 (2 minutes)', ->
        expect(AutoUpdatePackages.getAutoUpdateCheckInterval()).toBe(120000)
